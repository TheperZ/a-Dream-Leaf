package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
public class MyPageRepositoryImpl implements MyPageRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(MyPageDelDto myPageDelDto) {

        String sql = "DELETE FROM USER WHERE uid = "+myPageDelDto.getUid();
        jdbcTemplate.update(sql);
        return "No Content. 사용자 계정 삭제 완료";
    }
}
