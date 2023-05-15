package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.MyPageDto;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class MyPageRepositoryImpl implements MyPageRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<MyPageDto> myPageDtoRowMapper = (rs, rowNum) ->
            MyPageDto.builder()
                    .userId(rs.getInt("userId"))
                    .userName(rs.getString("userName"))
                    .email(rs.getString("email"))
                    .build();
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(MyPageDelDto myPageDelDto) {

        String sql = "DELETE FROM USER WHERE uid = "+myPageDelDto.getUid();
        jdbcTemplate.update(sql);
        return "No Content. 사용자 계정 삭제 완료";
    }

    @Override
    public MyPageDto inquire(String id) {
        MyPageDto myPageDto = jdbcTemplate.queryForObject("SELECT userId, userName, email FROM USER WHERE uid = "+ id
                ,myPageDtoRowMapper);
        return myPageDto;
    }
}
