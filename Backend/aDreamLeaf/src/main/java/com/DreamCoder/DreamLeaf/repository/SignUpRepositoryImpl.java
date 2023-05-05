package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;
import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SignUpRepositoryImpl implements SignUpRepository{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<SignUpDto> signupRowMapper = (rs, rowNum) ->
            SignUpDto.builder()
                    .uid(rs.getInt("uid"))
                    //.userName(rs.getString("userName"))
                    .email(rs.getString("email"))
                    .userId(rs.getInt("userId"))
                    .build();

    @Override
    public SignUpDto save(SignUpCreateDto signUpCreateDto) {
        jdbcTemplate.execute("INSERT INTO USER(userName,email,userId) VALUES('"+
                signUpCreateDto.getEmail()+
                "','"+signUpCreateDto.getUserId()+
                "')");
        SignUpDto signUpDto = jdbcTemplate.queryForObject("SELECT * FROM user WHERE email = '"+signUpCreateDto.getEmail()+
                "' AND userId = "+ signUpCreateDto.getUserId(),signupRowMapper);
        return signUpDto;
    }
}