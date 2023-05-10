package com.DreamCoder.DreamLeaf.repository;


import com.DreamCoder.DreamLeaf.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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
        String sql2 = "SELECT remain FROM ACCOUNTLOG WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        String sql3 = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        int remain = jdbcTemplate.queryForObject(sql2,Integer.class,accountCreateDto.getUserId(),startDate,endDate); // 만약 accountlog가 없으면? 오류처리 필수.
        if(remain>= accountCreateDto.getPrice()){
            jdbcTemplate.execute(sql);
            jdbcTemplate.update(sql3,(remain- accountCreateDto.getPrice()),accountCreateDto.getUserId(),startDate,endDate);
        } else{
            // Custom Exception 발생
        }
        AccountDto accountDto = jdbcTemplate.queryForObject("SELECT * FROM account WHERE accountBody = '"+accountCreateDto.getBody()+
                "' AND created_date = '"+accountCreateDto.getDate()+"' AND userId = "+ accountCreateDto.getUserId(),accountRowMapper);
        return accountDto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(AccountDelDto accountDelDto) { //삭제 권한 확인 추가 필요 및 예외처리 필요
        String currentDate;
        String startDate;
        String endDate;
        int price;
        int remain;
        String sql = "DELETE FROM ACCOUNT WHERE accountId = "+accountDelDto.getAccountId();
        String sql2 = "SELECT created_date FROM account WHERE accountId = ?";
        String sql3 = "SELECT price FROM account WHERE accountId = ?";
        String sql4 = "SELECT remain FROM ACCOUNTLOG WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        String sql5 = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        currentDate = jdbcTemplate.queryForObject(sql2,String.class,accountDelDto.getAccountId());
        price = jdbcTemplate.queryForObject(sql3,Integer.class,accountDelDto.getAccountId());
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        remain = jdbcTemplate.queryForObject(sql4,Integer.class,accountDelDto.getUserId(),startDate,endDate);
        remain += price;
        jdbcTemplate.update(sql5,remain,accountDelDto.getUserId(),startDate,endDate);
        jdbcTemplate.update(sql);
        return "삭제가 완료 되었습니다.";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String update(AccountUpDto accountUpDto) { //수정 권한 확인 추가 필요 및 예외처리 필요
        String sql = "UPDATE ACCOUNT SET restaurant = ?, price = ?, Created_date = ?, accountBody = ? WHERE accountId = ?";
        String sql2 = "SELECT * FROM ACCOUNT WHERE accountId = ?";
        String sql3 = "SELECT created_date FROM account WHERE accountId = ?";
        String sql4 = "SELECT price FROM account WHERE accountId = ?";
        String sql5 = "SELECT remain FROM ACCOUNTLOG WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        String sql6 = "UPDATE ACCOUNTLOG SET remain = ? WHERE userId = ? AND createdDate BETWEEN ? AND ?";
        String startDate;
        String endDate;
        String currentDate = jdbcTemplate.queryForObject(sql3,String.class,accountUpDto.getAccountId());
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        int price = jdbcTemplate.queryForObject(sql4,Integer.class,accountUpDto.getAccountId());
        int remain = jdbcTemplate.queryForObject(sql5,Integer.class,accountUpDto.getUserId(),startDate,endDate);
        remain += price;
        jdbcTemplate.update(sql6,remain,accountUpDto.getUserId(),startDate,endDate); // accountlog를 account 작성 전으로 수정
        currentDate = accountUpDto.getDate();
        currentDate = currentDate.substring(0,currentDate.length()-3);
        startDate = currentDate+"-01";
        endDate = currentDate+"-31";
        remain = jdbcTemplate.queryForObject(sql5,Integer.class,accountUpDto.getUserId(),startDate,endDate);
        if(remain >= accountUpDto.getPrice()){
            jdbcTemplate.update(sql6,remain- accountUpDto.getPrice(),accountUpDto.getUserId(),startDate,endDate);
            jdbcTemplate.update(sql,accountUpDto.getRestaurant(),accountUpDto.getPrice(),accountUpDto.getDate(),accountUpDto.getBody(),accountUpDto.getAccountId()); //내용 업데이트
        } else{
            // Custom Exception 발생
        }
        return "수정이 완료 되었습니다.";
    }

    @Override
    public List<AccountListResultDto> search(AccountListDto accountListDto) {
        List<AccountListResultDto> results = new ArrayList<>();
        String Date = accountListDto.getYearMonth();
        String startDate = Date+"-01";
        String endDate = Date+"-31";
        String sql = "SELECT * FROM account WHERE userId = ? and created_date LIKE ?  ORDER BY created_date DESC"; // 이것도 없을 수도 있어서 오류 처리 필요
        String sql2 = "SELECT remain from accountlog where userId = ? and createdDate >= ? and createdDate <= ?"; // 이것도 없을 수도 있어서 오류 처리 필요
        int remain = jdbcTemplate.queryForObject(sql2,Integer.class,accountListDto.getId(),startDate,endDate);
        results = jdbcTemplate.query(sql,accountResultRowMapper,accountListDto.getId(),Date+"%");
        for(AccountListResultDto result : results){
            result.setRemain(remain);
            remain += result.getPrice();
        }
        return results;
    }

    @Override
    public SimpleAccountDto inquire(int id) {
        String sql = "SELECT amount, remain FROM ACCOUNTLOG WHERE userId = ? and createdDate BETWEEN ? AND ?";
        YearMonth currentDate = YearMonth.now();
        String startDate = currentDate.toString()+"-01";
        String endDate = currentDate.toString()+"-31";
        SimpleAccountDto simpleAccountDto =  jdbcTemplate.queryForObject(sql,simpleAccountDtoRowMapper,id,startDate,endDate);
        simpleAccountDto.setCharge(simpleAccountDto.getCharge()- simpleAccountDto.getBalance());
        return simpleAccountDto;
    }

    @Override
    public String set(AccountSetDto accountSetDto) {
        String sql = "SELECT userId FROM accountsetting WHERE userId = ?";
        int id;
        try{
            id = jdbcTemplate.queryForObject(sql,Integer.class,accountSetDto.getUserId());
        } catch(EmptyResultDataAccessException e){
            id = -1;
        }
        if(id == -1){
            String sql2 = "INSERT INTO accountsetting VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW())";
            jdbcTemplate.execute(sql2);
            String sql3 = "INSERT INTO accountlog VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW(),"+accountSetDto.getAmount()+")";
            jdbcTemplate.execute(sql3);
        } else{
            String sql2 = "UPDATE accountsetting SET amount = ?, createdDate = NOW() WHERE userId = ?";
            jdbcTemplate.update(sql2,accountSetDto.getAmount(),accountSetDto.getUserId());
            String sql4 = "UPDATE accountlog SET amount = ?, createdDate = NOW(), remain = ? WHERE userId = ?";
            int amount = jdbcTemplate.queryForObject("SELECT amount FROM accountlog WHERE userId = ?",Integer.class,accountSetDto.getUserId());
            int remain = jdbcTemplate.queryForObject("SELECT remain FROM accountlog WHERE userId = ?",Integer.class,accountSetDto.getUserId());
            remain += (accountSetDto.getAmount()-amount);
            jdbcTemplate.update(sql4,accountSetDto.getAmount(),remain,accountSetDto.getUserId());
        }
        return "설정이 완료 되었습니다.";
    }
}
