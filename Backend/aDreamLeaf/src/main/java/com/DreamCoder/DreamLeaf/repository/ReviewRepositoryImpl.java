package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.exception.ReviewException;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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
    @Transactional(rollbackFor = Exception.class)
    public ReviewDto save(ReviewCreateDto reviewCreateDto) {

        validateUserId(reviewCreateDto.getUserId());

        String userName = getUserName(reviewCreateDto.getUserId());
        String storeName = getStoreName(reviewCreateDto.getStoreId());

        if (reviewCreateDto.getRating() > 5 || reviewCreateDto.getRating() < 1 || reviewCreateDto.getBody().length() < 10){
            throw new ReviewException("잘못된 리뷰 형식입니다.", 400);
        }

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

        reviewDto.setNameData(userName, storeName);

        return reviewDto;
    }

    @Override
    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto) {
        int count = countReview(reviewSearchDto.getStoreId());
        if(count != 0){
            reviewSearchDto.setReviewPagination(new ReviewPagination(count, reviewSearchDto));
        }
        else{
            throw new ReviewException("해당 가게의 리뷰가 존재하지 않습니다.", 404);
        }

        List<ReviewDto> reviewDtoList = jdbcTemplate.query("SELECT * FROM REVIEW WHERE storeId="+reviewSearchDto.getStoreId()
                        + " ORDER BY created_date DESC LIMIT " + reviewSearchDto.getDisplay()
                        + " OFFSET " + reviewSearchDto.getReviewPagination().getLimitStart()
                , reviewRowMapper);

        if (reviewDtoList.isEmpty()){
            throw new ReviewException("해당 가게의 페이지에 리뷰가 존재하지 않습니다.", 404);
        }
        
        String storeName = getStoreName(reviewSearchDto.getStoreId());
        for (ReviewDto reviewDto : reviewDtoList){
            reviewDto.setNameData(getUserName(reviewDto.getUserId()), storeName);
        }
        return reviewDtoList;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String update(ReviewUpDto reviewUpDto) {

        int writerId = getWriterId(reviewUpDto.getReviewId());
        if (writerId != reviewUpDto.getUserId()){
            throw new ReviewException("수정 권한이 없습니다.", 403);
        }

        if (reviewUpDto.getRating() > 5 || reviewUpDto.getRating() < 1 || reviewUpDto.getBody().length() < 10){
            throw new ReviewException("잘못된 리뷰 형식입니다.", 400);
        }

        jdbcTemplate.update("UPDATE REVIEW SET created_date='"+reviewUpDto.getDate()+
                "', body='"+reviewUpDto.getBody()+
                "', rating="+reviewUpDto.getRating()+
                " WHERE reviewId="+reviewUpDto.getReviewId()
                );
        return "수정이 완료 되었습니다.";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(ReviewDelDto reviewDelDto) {

        int writerId = getWriterId(reviewDelDto.getReviewId());
        if (writerId != reviewDelDto.getUserId()){
            throw new ReviewException("삭제 권한이 없습니다.", 403);
        }

        jdbcTemplate.update("DELETE FROM REVIEW WHERE reviewId="+reviewDelDto.getReviewId());
        return "삭제가 완료 되었습니다.";
    }

    @Override
    public int countReview(int storeId) {
        int count = jdbcTemplate.queryForObject("SELECT count(*) FROM REVIEW WHERE storeId="+storeId, Integer.class);
        return count;
    }

    @Override
    public void validateUserId(int userId) {
        try{
            jdbcTemplate.queryForObject("SELECT userId FROM USER WHERE userId="+userId, Integer.class);
        }
        catch (EmptyResultDataAccessException ex){
            throw new ReviewException("리뷰 작성 권한이 없습니다.", 403);
        }
    }

    @Override
    public String getUserName(int userId) {
        String userName;
        try{
            userName = jdbcTemplate.queryForObject("SELECT userName FROM USER WHERE userId="+userId, String.class);
        }
        catch (Exception ex){
            throw new ReviewException("조회하려는 리뷰가 존재하지 않습니다", 404);
        }
        return userName;
    }

    @Override
    public String getStoreName(int storeId) {
        String sql = "SELECT storeName FROM store WHERE storeId = ?";
        String storeName;
        try{
            storeName = jdbcTemplate.queryForObject(sql, String.class, storeId);
        }
        catch (Exception ex){
            throw new ReviewException("조회하려는 리뷰가 존재하지 않습니다.", 404);
        }
        return storeName;
    }

    @Override
    public int getWriterId(int reviewId) {
        String sql = "SELECT userId FROM review WHERE reviewId = ?";
        int writerId;
        try{
            writerId = jdbcTemplate.queryForObject(sql, Integer.class, reviewId);
        }
        catch (EmptyResultDataAccessException ex){
            throw new ReviewException("조회하려는 리뷰가 존재하지 않습니다.", 404);
        }
        return writerId;
    }
}
