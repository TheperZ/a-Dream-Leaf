package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.MyPageDelDto2;
import com.DreamCoder.DreamLeaf.dto.MyPageDto;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import com.DreamCoder.DreamLeaf.exception.MyPageException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
public class MyPageRepositoryImpl implements MyPageRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<MyPageDelDto2> myPageDelDto2RowMapper = (rs, rowNum) ->
            MyPageDelDto2.builder()
                    .userId(rs.getInt("userId"))
                    .build();

    private final RowMapper<MyPageDto> myPageDtoRowMapper = (rs, rowNum) ->
            MyPageDto.builder()
                    .userId(rs.getInt("userId"))
                    .userName(rs.getString("userName"))
                    .email(rs.getString("email"))
                    .build();
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(MyPageDelDto myPageDelDto) {

        int writerId = myPageDelDto.getUserId();

        MyPageDelDto2 myPageDelDto2 = jdbcTemplate.queryForObject("SELECT userId FROM user WHERE userId = "+ myPageDelDto.getUserId(),myPageDelDto2RowMapper);

        if (writerId != myPageDelDto2.getUserId()){
            throw new MyPageException("삭제 권한이 없습니다.", 403);
        }

        try{
            String sql = "DELETE FROM user WHERE userId = " + myPageDelDto.getUserId();
            jdbcTemplate.update(sql);
        }
        catch(Exception e){
            throw new MyPageException("사용자 정보를 찾을 수 없습니다.", 404);
        }

        return "No Content. 사용자 계정 삭제 완료";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public MyPageDto inquire(int id) {
        MyPageDto myPageDto;

        try{
            myPageDto = jdbcTemplate.queryForObject("SELECT userId, userName, email FROM user WHERE userId = "+ id
                    ,myPageDtoRowMapper);
        }
        catch(EmptyResultDataAccessException ex){
            throw new MyPageException("사용자 정보를 찾을 수 없습니다.", 404);
        }

        int writerId = myPageDto.getUserId();
        if (writerId != id){
            throw new MyPageException("조회 권한이 없습니다.", 403);
        }

        return myPageDto;
    }
}
