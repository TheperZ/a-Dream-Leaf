package com.DreamCoder.DreamLeaf.repository;


import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.exception.AccountException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

@Repository
public class AccountRepositoryImpl implements AccountRepository{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<AccountDto> accountRowMapper = (rs, rowNum) ->
            AccountDto.builder()
                    .accountId(rs.getInt("accountId"))
                    .restaurant(rs.getString("restaurant"))
                    .price(rs.getInt("price"))
                    .date(rs.getString("created_date"))
                    .body(rs.getString("accountBody"))
                    .userId(rs.getInt("userId"))
                    .build();

    private final RowMapper<AccountListResultDto> accountResultRowMapper = (rs, rowNum) ->
            AccountListResultDto.builder()
                    .accountId(rs.getInt("accountId"))
                    .restaurant(rs.getString("restaurant"))
                    .price(rs.getInt("price"))
                    .date(rs.getString("created_date"))
                    .body(rs.getString("accountBody"))
                    .userId(rs.getInt("userId"))
                    .remain(0)
                    .build();

    private final RowMapper<SimpleAccountDto> simpleAccountDtoRowMapper = (rs, rowNum) ->
            SimpleAccountDto.builder()
                    .balance(rs.getInt("remain"))
                    .charge(rs.getInt("amount"))
                    .build();

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AccountDto save(AccountCreateDto accountCreateDto) {
        String sql = "INSERT INTO ACCOUNT(restaurant,price,created_date,accountBody,userId) VALUES('"+
                accountCreateDto.getRestaurant()+
                "','"+accountCreateDto.getPrice()+
                "','"+accountCreateDto.getDate()+
                "','"+accountCreateDto.getBody()+
                "','"+accountCreateDto.getUserId()+
                "')";
        String currentDate = accountCreateDto.getDate();
        currentDate = currentDate.substring(0,currentDate.length()-3);
        String startDate = currentDate+"-01";
        String endDate = currentDate+"-31";
        String updateSql = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        int remain = getRemain(accountCreateDto.getUserId(),startDate,endDate);
        if(remain>= accountCreateDto.getPrice()){
            jdbcTemplate.execute(sql);
            jdbcTemplate.update(updateSql,(remain- accountCreateDto.getPrice()),accountCreateDto.getUserId(),startDate,endDate);
        } else{
            throw new AccountException("예산이 초과 되었습니다.",400); // 오류처리
        }
        AccountDto accountDto = jdbcTemplate.queryForObject("SELECT * FROM account WHERE accountBody = '"+accountCreateDto.getBody()+
                "' AND created_date = '"+accountCreateDto.getDate()+"' AND userId = "+ accountCreateDto.getUserId(),accountRowMapper);
        return accountDto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(AccountDelDto accountDelDto) { //삭제 권한 확인 추가 필요 및 예외처리 필요
        int writerId = getWriteId(accountDelDto.getAccountId());
        if(writerId != accountDelDto.getUserId())
            throw new AccountException("삭제 권한이 없습니다.", 403);
        String currentDate;
        String startDate;
        String endDate;
        int price;
        int remain;
        String sql = "DELETE FROM ACCOUNT WHERE accountId = "+accountDelDto.getAccountId();
        String updateLogSql = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        currentDate = getCreatedDate(accountDelDto.getAccountId());
        price = getPrice(accountDelDto.getAccountId());
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        remain = getRemain(accountDelDto.getUserId(),startDate,endDate);
        remain += price;
        jdbcTemplate.update(updateLogSql,remain,accountDelDto.getUserId(),startDate,endDate);
        jdbcTemplate.update(sql);
        return "삭제가 완료 되었습니다.";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String update(AccountUpDto accountUpDto) { //수정 권한 확인 추가 필요 및 예외처리 필요
        int writerId = getWriteId(accountUpDto.getAccountId());
        if(writerId != accountUpDto.getUserId())
            throw new AccountException("수정 권한이 없습니다.", 403);
        String sql = "UPDATE ACCOUNT SET restaurant = ?, price = ?, Created_date = ?, accountBody = ? WHERE accountId = ?";
        String sql6 = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        String startDate;
        String endDate;
        String currentDate = getCreatedDate(accountUpDto.getAccountId());
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        int price = getPrice(accountUpDto.getAccountId());
        int remain = getRemain(accountUpDto.getUserId(),startDate,endDate);
        remain += price;
        jdbcTemplate.update(sql6,remain,accountUpDto.getUserId(),startDate,endDate); // accountlog를 account 작성 전으로 수정
        currentDate = accountUpDto.getDate();
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        remain = getRemain(accountUpDto.getUserId(),startDate,endDate);
        if(remain >= accountUpDto.getPrice()){
            jdbcTemplate.update(sql6,remain- accountUpDto.getPrice(),accountUpDto.getUserId(),startDate,endDate);
            jdbcTemplate.update(sql,accountUpDto.getRestaurant(),accountUpDto.getPrice(),accountUpDto.getDate(),accountUpDto.getBody(),accountUpDto.getAccountId()); //내용 업데이트
        } else{
            throw new AccountException("예산이 초과 되었습니다.",400); // 오류처리
        }
        return "수정이 완료 되었습니다.";
    }

    @Override
    public List<AccountListResultDto> search(AccountListDto accountListDto) {
        List<AccountListResultDto> results = new ArrayList<>();
        String Date = accountListDto.getYearMonth();
        String startDate = Date+"-01";
        String endDate = Date+"-31";
        String sql = "SELECT * FROM account WHERE userId = ? and created_date LIKE ?  ORDER BY created_date DESC";
        int remain = getRemain(accountListDto.getId(),startDate,endDate);
        results = jdbcTemplate.query(sql,accountResultRowMapper,accountListDto.getId(),Date+"%");
        for(AccountListResultDto result : results){
            result.setRemain(remain);
            remain += result.getPrice();
        }
        return results;
    }

    @Override
    public SimpleAccountDto inquire(AccountInqDto accountInqDto) {
        String sql = "SELECT amount, remain FROM ACCOUNTLOG WHERE userId = ? and createdDate >= ? AND createdDate <= ?";
        String currentDate = accountInqDto.getYearMonth();
        String startDate = currentDate+"-01";
        String endDate = currentDate+"-31";
        SimpleAccountDto simpleAccountDto;
        try{
            simpleAccountDto =  jdbcTemplate.queryForObject(sql,simpleAccountDtoRowMapper,accountInqDto.getId(),startDate,endDate);
        } catch(EmptyResultDataAccessException ex){
            throw new AccountException("조회하고자 하는 기간에 대한 예산 설정 값 및 가계부 작성 내역이 존재하지 않습니다.",404); // 오류처리
        }
        simpleAccountDto.setCharge(simpleAccountDto.getCharge()- simpleAccountDto.getBalance());
        return simpleAccountDto;
    }

    @Override
    @Transactional(rollbackFor = AccountException.class)
    public String set(AccountSetDto accountSetDto) {
        String sql = "SELECT userId FROM accountsetting WHERE userId = ?";
        int id;
        YearMonth now = YearMonth.now();
        String current = now.toString();
        String startDate = current + "-01";
        String endDate = current + "-31";
        try{
            id = jdbcTemplate.queryForObject(sql,Integer.class,accountSetDto.getUserId());
        } catch(EmptyResultDataAccessException e){
            id = -1;
        }
        if(id == -1){
            String sql2 = "INSERT INTO accountsetting VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW())";
            jdbcTemplate.execute(sql2);
            String sql3 = "INSERT INTO accountlog(userId,amount,createdDate,remain) VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW(),"+accountSetDto.getAmount()+")";
            jdbcTemplate.execute(sql3);
        } else{
            String sql2 = "UPDATE accountsetting SET amount = ?, createdDate = NOW() WHERE userId = ?";
            jdbcTemplate.update(sql2,accountSetDto.getAmount(),accountSetDto.getUserId());
            String sql4 = "UPDATE accountlog SET amount = ?, createdDate = NOW(), remain = ? WHERE userId = ? and createdDate >= ? and createdDate <= ?";
            int amount = getAmount(accountSetDto.getUserId(),startDate,endDate);
            int remain = getRemain(accountSetDto.getUserId(),startDate,endDate);
            remain += (accountSetDto.getAmount()-amount);
            if(remain < 0)
                throw new AccountException("예산 초과입니다.",400);
            jdbcTemplate.update(sql4,accountSetDto.getAmount(),remain,accountSetDto.getUserId(),startDate,endDate);
        }
        return "설정이 완료 되었습니다.";
    }

    @Override
    public int getRemain(int userId,String startDate, String endDate) {
        String sql = "SELECT remain from accountlog where userId = ? and createdDate >= ? and createdDate <= ?";
        int remain;
        try{
            remain = jdbcTemplate.queryForObject(sql,Integer.class,userId,startDate,endDate);
        } catch(Exception ex){
            throw new AccountException("가계부 예산 설정을 먼저 진행해주세요.",403); // 오류처리
        }
        return remain;
    }

    @Override
    public int getAmount(int userId,String startDate, String endDate) {
        String sql = "SELECT amount FROM accountlog WHERE userId = ? and createdDate >= ? and createdDate <= ?";
        int amount;
        try{
            amount = jdbcTemplate.queryForObject(sql,Integer.class,userId,startDate,endDate);
        } catch(Exception ex){
            ex.printStackTrace(); // 오류처리
            throw new AccountException("가계부 예산 설정을 먼저 진행해주세요.",400); // 오류처리
        }
        return amount;
    }

    @Override
    public String getCreatedDate(int accountId) {
        String sql = "SELECT created_date FROM account WHERE accountId = ?";
        String createdDate = "";
        try{
            createdDate = jdbcTemplate.queryForObject(sql,String.class,accountId);
        } catch(Exception ex){
            throw new AccountException("조회하려는 가계부 내역이 존재하지 않습니다.",404); // 오류처리
        }
        return createdDate;
    }

    @Override
    public int getPrice(int accountId) {
        String sql = "SELECT price FROM account WHERE accountId = ?";
        int price = -1;
        try{
            price = jdbcTemplate.queryForObject(sql,Integer.class,accountId);
        } catch(Exception ex){
            throw new AccountException("조회하려는 가계부 내역이 존재하지 않습니다.",404); // 오류처리
        }
        return price;
    }

    @Override
    public int getWriteId(int accountId) {
        String sql = "SELECT userId FROM account WHERE accountId = ?";
        int id;
        try {
            id = jdbcTemplate.queryForObject(sql,Integer.class,accountId);
        } catch(EmptyResultDataAccessException ex){
            throw new AccountException("조회하려는 가계부 내역이 존재하지 않습니다.",404);
        }
        return id;
    }
}
