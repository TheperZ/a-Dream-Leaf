package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.support.DataAccessUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepository{

    private final JdbcTemplate jdbcTemplate;
    
    private final RowMapper<ReviewDto> reviewRowMapper = new RowMapper<ReviewDto>() {
        @Override
        public ReviewDto mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new ReviewDto(
                    rs.getInt("userId"),
                    rs.getInt("reviewId"),
                    rs.getInt("storeId"),
                    rs.getString("created_date"),
                    rs.getString("body"),
                    rs.getInt("rating"));
        }
    };

    @Override
    public ReviewDto save(ReviewCreateDto reviewCreateDto) {
        jdbcTemplate.execute("INSERT INTO REVIEW(storeId,created_date,body,rating, userId) VALUES(" +
                reviewCreateDto.getStoreId()+
                ",'" + reviewCreateDto.getDate()+
                "','" + reviewCreateDto.getBody()+
                "'," + reviewCreateDto.getRating()+
                "," + reviewCreateDto.getUserId()+
                ")");
        ReviewDto reviewDto = jdbcTemplate.queryForObject("SELECT * FROM REVIEW WHERE body = '"+reviewCreateDto.getBody()+
                "' AND created_date = '"+reviewCreateDto.getDate()+
                "' AND storeId = "+reviewCreateDto.getStoreId()+
                " AND userId = "+reviewCreateDto.getUserId(), reviewRowMapper);

        reviewDto.setNameData(findUserName(reviewDto.getUserId()), findStoreName(reviewDto.getStoreId()));

        return reviewDto;
    }

    @Override
    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto) {
        List<ReviewDto> reviewDtoList = jdbcTemplate.query("SELECT * FROM REVIEW WHERE storeId="+reviewSearchDto.getStoreId()
                        + " ORDER BY created_date DESC LIMIT " + reviewSearchDto.getDisplay()
                        + " OFFSET " + reviewSearchDto.getReviewPagination().getLimitStart()
                , reviewRowMapper);
        for (ReviewDto reviewDto : reviewDtoList){
            reviewDto.setNameData(findUserName(reviewDto.getUserId()), findStoreName(reviewDto.getStoreId()));
        }
        return reviewDtoList;
    }

    @Override
    public String update(ReviewUpDto reviewUpDto) {
        jdbcTemplate.update("UPDATE REVIEW SET created_date='"+reviewUpDto.getDate()+
                "', body='"+reviewUpDto.getBody()+
                "', rating="+reviewUpDto.getRating()+
                " WHERE reviewId="+reviewUpDto.getReviewId()
                );
        return "수정이 완료되었습니다.";
    }

    @Override
    public String delete(ReviewDelDto reviewDelDto) {
        jdbcTemplate.update("DELETE FROM REVIEW WHERE reviewId="+reviewDelDto.getReviewId());
        return "삭제가 완료되었습니다.";
    }

    @Override
    public Integer CountReview(int storeId) {
        Integer count =  jdbcTemplate.queryForObject("SELECT count(*) FROM REVIEW WHERE storeId="+storeId, Integer.class);
        return count;
    }

    @Override
    public String findUserName(int userId) {
        return jdbcTemplate.queryForObject("SELECT userName FROM USER WHERE userId="+userId, String.class);
    }

    @Override
    public String findStoreName(int storeId) {
        return jdbcTemplate.queryForObject("SELECT storeName FROM STORE WHERE storeId="+storeId, String.class);
    }
}
