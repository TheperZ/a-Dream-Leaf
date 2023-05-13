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

    private final RowMapper<SignUpDto> signUpRowMapper = (rs, rowNum) ->
            SignUpDto.builder()
                    .userId(rs.getInt("userId"))
                    .uid(rs.getString("uid"))
                    .userName(rs.getString("userName"))
                    .email(rs.getString("email"))
                    .build();

    @Override
    public SignUpDto save(SignUpCreateDto signUpCreateDto) {
        jdbcTemplate.execute("INSERT INTO USER(email,uid,userName) VALUES('"+
                signUpCreateDto.getEmail()+
                "','"+signUpCreateDto.getUid()+
                "','"+signUpCreateDto.getUserName()+"')");
        SignUpDto signUpDto = jdbcTemplate.queryForObject("SELECT * FROM user WHERE email = '"+signUpCreateDto.getEmail()+
                "' AND uid = "+ signUpCreateDto.getUid(),signUpRowMapper);
        return signUpDto;
    }
}