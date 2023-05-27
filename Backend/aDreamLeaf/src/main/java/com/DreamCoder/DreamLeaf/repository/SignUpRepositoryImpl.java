package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;
import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import com.DreamCoder.DreamLeaf.dto.LoginDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import com.DreamCoder.DreamLeaf.exception.SignUpException;
import org.springframework.transaction.annotation.Transactional;


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

    private final RowMapper<LoginDto> loginDtoRowMapper = (rs, rowNum) ->
            LoginDto.builder()
                    .userId(rs.getInt("userId"))
                    .email(rs.getString("email"))
                    .userName(rs.getString("userName"))
                    .build();

    /*@Override
    public SignUpDto save(SignUpCreateDto signUpCreateDto) {
        jdbcTemplate.execute("INSERT INTO USER(email,uid,userName) VALUES('"+
                signUpCreateDto.getEmail()+
                "','"+signUpCreateDto.getUid()+
                "','"+signUpCreateDto.getUserName()+"')");
        SignUpDto signUpDto = jdbcTemplate.queryForObject("SELECT * FROM user WHERE email = '"+signUpCreateDto.getEmail()+
                "' AND uid = "+ signUpCreateDto.getUid(),signUpRowMapper);
        return signUpDto;
    }*/
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String save(SignUpCreateDto signUpCreateDto) {
        String email = signUpCreateDto.getEmail();
        if (!isValidEmail(email)) {
            throw new SignUpException("Bad Request. 입력된 정보가 올바르지 않음", 400);
        }
        jdbcTemplate.execute("INSERT INTO USER(email,uid,userName) VALUES('"+
                signUpCreateDto.getEmail()+
                "','"+signUpCreateDto.getUid()+
                "','"+signUpCreateDto.getUserName()+"')");

        return "Created. 회원가입 완료";

    }

    @Override
    public LoginDto inquire(int id) {
        LoginDto loginDto = jdbcTemplate.queryForObject("SELECT userId, email, userName FROM USER WHERE userId = "+ id
                ,loginDtoRowMapper);
        return loginDto;
    }

    @Override
    public boolean isValidEmail(String email) {
        String emailRegex = "^(?=.{1,64}@)[A-Za-z0-9_-]+(?:\\.[A-Za-z0-9_-]+)*@(?!-)(?:[A-Za-z0-9-]{1,63}\\.)*(?:[A-Za-z]{2,63}|(?:[0-9]{1,3}\\.){3}[0-9]{1,3})(?:\\:\\d{2,5})?$";
        return email.matches(emailRegex);
    }

}