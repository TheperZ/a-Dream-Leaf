package com.DreamCoder.DreamLeaf.repository;


import com.DreamCoder.DreamLeaf.dto.AccountCreateDto;
import com.DreamCoder.DreamLeaf.dto.AccountDelDto;
import com.DreamCoder.DreamLeaf.dto.AccountDto;
import com.DreamCoder.DreamLeaf.dto.AccountUpDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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

    @Override
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
}
