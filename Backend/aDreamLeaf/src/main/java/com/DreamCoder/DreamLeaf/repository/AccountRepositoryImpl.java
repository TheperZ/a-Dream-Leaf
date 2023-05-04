package com.DreamCoder.DreamLeaf.repository;


import com.DreamCoder.DreamLeaf.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
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
        jdbcTemplate.execute(sql);
        AccountDto accountDto = jdbcTemplate.queryForObject("SELECT * FROM account WHERE body = '"+accountCreateDto.getBody()+
                "' AND created_date = '"+accountCreateDto.getDate()+"' AND userId = "+ accountCreateDto.getUserId(),accountRowMapper);
        return accountDto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(AccountDelDto accountDelDto) { //삭제 권한 확인 추가 필요 및 예외처리 필요
        String sql = "DELETE FROM ACCOUNT WHERE accountId = "+accountDelDto.getAccountId();
        jdbcTemplate.update(sql);
        return "삭제가 완료 되었습니다.";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AccountDto update(AccountUpDto accountUpDto) { //수정 권한 확인 추가 필요 및 예외처리 필요
        String sql = "UPDATE ACCOUNT SET restaurant = ?, price = ?, date = ?, body = ? WHERE accountId = ?";
        jdbcTemplate.update(sql,accountUpDto.getRestaurant(),accountUpDto.getPrice(),accountUpDto.getDate(),accountUpDto.getBody(),accountUpDto.getUserId());
        String sql2 = "SELECT * FROM ACCOUNT WHERE accountId = ?";
        AccountDto result = jdbcTemplate.queryForObject(sql2,accountRowMapper,accountUpDto.getAccountId());
        return result;
    }

    @Override
    public SimpleAccountDto inquire(int id) {
        String sql = "SELECT amount, remain FROM ACCOUNTLOG WHERE userId = ? and createdDate = ?";
        YearMonth currentDate = YearMonth.now();
        String date = currentDate+"%";
        SimpleAccountDto simpleAccountDto =  jdbcTemplate.queryForObject(sql,simpleAccountDtoRowMapper,id,date);
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
        if(id != -1){
            String sql2 = "INSERT INTO accountsetting VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW())";
            jdbcTemplate.execute(sql2);
            String sql3 = "INSERT INTO accountlog VALUES ("+accountSetDto.getUserId()+","+accountSetDto.getAmount()+",NOW(),"+accountSetDto.getAmount()+")";
        } else{
            String sql2 = "UPDATE accountsetting SET amount = ?, createdDate = NOW() WHERE userId = ?";
            jdbcTemplate.update(sql2,accountSetDto.getAmount(),accountSetDto.getUserId());
            String sql3 = "SELECT amount,remain FROM accountlog WHERE userId = "+accountSetDto.getUserId();
            String sql4 = "UPDATE accountlog SET amount = ?, createdDate = NOW(), remain = ? WHERE userId = ?";
            int amount = jdbcTemplate.queryForObject("SELECT amount FROM accountlog WHERE userId = ?",Integer.class,accountSetDto.getUserId());
            int remain = jdbcTemplate.queryForObject("SELECT remain FROM accountlog WHERE userId = ?",Integer.class,accountSetDto.getUserId());
            remain += (accountSetDto.getAmount()-amount);
            jdbcTemplate.update(sql3);
            jdbcTemplate.update(sql4,accountSetDto.getAmount(),remain,accountSetDto.getUserId());
        }
        return "설정이 완료 되었습니다.";
    }
}
