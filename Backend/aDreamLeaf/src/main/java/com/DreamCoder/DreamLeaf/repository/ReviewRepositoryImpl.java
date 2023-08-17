package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.exception.ReviewException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepository{

    @Autowired
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

    @Value("${images.path}")
    private String dirPath;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ReviewDto save(ReviewCreateDto reviewCreateDto) {

        validateUserId(reviewCreateDto.getUserId());

        String userName = getUserName(reviewCreateDto.getUserId());
        String storeName = getStoreName(reviewCreateDto.getStoreId());

        if (reviewCreateDto.getRating() > 5 || reviewCreateDto.getRating() < 1 || reviewCreateDto.getBody().length() < 10){
            throw new ReviewException("잘못된 리뷰 형식입니다.", 400);
        }

        jdbcTemplate.execute("INSERT INTO review(storeId,created_date,body,rating, userId) VALUES(" +
                reviewCreateDto.getStoreId()+
                ",'" + reviewCreateDto.getDate()+
                "','" + reviewCreateDto.getBody()+
                "'," + reviewCreateDto.getRating()+
                "," + reviewCreateDto.getUserId()+
                ")");
        ReviewDto reviewDto;
        try {
            reviewDto = jdbcTemplate.queryForObject("SELECT * FROM review WHERE body = '" + reviewCreateDto.getBody() +
                    "' AND created_date = '" + reviewCreateDto.getDate() +
                    "' AND storeId = " + reviewCreateDto.getStoreId() +
                    " AND userId = " + reviewCreateDto.getUserId(), reviewRowMapper);
        }
        catch (Exception e){
            throw new ReviewException("유효하지 않은 리뷰입니다.", 400);
        }
        reviewDto.setNameData(userName, storeName);
        if (reviewCreateDto.getReviewImage().isPresent()) {
            saveReviewImage(reviewDto.getDate(), reviewDto.getStoreId(), reviewDto.getReviewId(), reviewCreateDto.getReviewImage().get());
            reviewDto.setReviewImage(reviewCreateDto.getReviewImage().get());
        }
        else{
            reviewDto.setReviewImage(null);
        }
        return reviewDto;
    }

    @Override
    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto) {
        int count = countReview(reviewSearchDto.getStoreId());
        if(count != 0 && reviewSearchDto.getDisplay() > 0){
            reviewSearchDto.setReviewPagination(new ReviewPagination(count, reviewSearchDto));
        }
        else{
            throw new ReviewException("해당 가게의 리뷰가 존재하지 않습니다.", 404);
        }

        List<ReviewDto> reviewDtoList = jdbcTemplate.query("SELECT * FROM review WHERE storeId="+reviewSearchDto.getStoreId()
                        + " ORDER BY created_date DESC LIMIT " + reviewSearchDto.getDisplay()
                        + " OFFSET " + reviewSearchDto.getReviewPagination().getLimitStart()
                , reviewRowMapper);
        if (reviewDtoList.isEmpty()){
            throw new ReviewException("해당 가게의 페이지에 리뷰가 존재하지 않습니다.", 404);
        }
        String storeName = getStoreName(reviewSearchDto.getStoreId());
        for (ReviewDto reviewDto : reviewDtoList){
            reviewDto.setNameData(getUserName(reviewDto.getUserId()), storeName);
            if (countReviewImage(reviewDto.getReviewId()) == 0){
                reviewDto.setReviewImage(null);
            }
            else{
                reviewDto.setReviewImage(getReviewImage(reviewDto.getReviewId()).getUrlResource());
            }
        }
        return reviewDtoList;
    }

    @Override
    public List<ReviewDto> findAllReview(int storeId) {
        int count = countReview(storeId);
        if(count == 0){
            throw new ReviewException("해당 가게의 리뷰가 존재하지 않습니다.", 404);
        }
        List<ReviewDto> reviewDtoList = jdbcTemplate.query("SELECT * FROM review WHERE storeId="+storeId+" ORDER BY created_date DESC"
                , reviewRowMapper);
        String storeName = getStoreName(storeId);
        for (ReviewDto reviewDto : reviewDtoList){
            reviewDto.setNameData(getUserName(reviewDto.getUserId()), storeName);
            if (countReviewImage(reviewDto.getReviewId()) == 0){
                reviewDto.setReviewImage(null);
            }
            else{
                reviewDto.setReviewImage(getReviewImage(reviewDto.getReviewId()).getUrlResource());
            }
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

        jdbcTemplate.update("UPDATE review SET created_date='"+reviewUpDto.getDate()+
                "', body='"+reviewUpDto.getBody()+
                "', rating="+reviewUpDto.getRating()+
                " WHERE reviewId="+reviewUpDto.getReviewId()
                );
        if (reviewUpDto.getReviewImage().isEmpty()) {
            delReviewImage(reviewUpDto.getReviewId());
        }
        else{
            if (countReviewImage(reviewUpDto.getReviewId()) == 0){
                saveReviewImage(reviewUpDto.getDate(), getStoreId(reviewUpDto.getReviewId()), reviewUpDto.getReviewId(), reviewUpDto.getReviewImage().get());
            }
            else{
                updateReviewImage(reviewUpDto.getDate(), getStoreId(reviewUpDto.getReviewId()), reviewUpDto.getReviewId(), reviewUpDto.getReviewImage().get());
            }
        }
        return "수정이 완료 되었습니다.";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(ReviewDelDto reviewDelDto) {

        int writerId = getWriterId(reviewDelDto.getReviewId());
        if (writerId != reviewDelDto.getUserId()){
            throw new ReviewException("삭제 권한이 없습니다.", 403);
        }
        if (countReviewImage(reviewDelDto.getReviewId()) != 0){
            delReviewImage(reviewDelDto.getReviewId());
        }

        try{
            jdbcTemplate.update("DELETE FROM review WHERE reviewId="+reviewDelDto.getReviewId());
        }
        catch(Exception e){
            throw new ReviewException("삭제할 리뷰를 찾을 수 없습니다.", 404);
        }
        return "삭제가 완료 되었습니다.";
    }

    @Override
    public ReviewImageDto getReviewImage(int reviewId) {
        String imageUrl;
        String imageTitle;
        String urlResource;

        String sql = "SELECT imageUrl FROM reviewImage WHERE reviewId = ?";
        String sql2 = "SELECT imageTitle FROM reviewImage WHERE reviewId = ?";

        String rootPath;
        try{
            rootPath = (Paths.get("").toRealPath() + dirPath).replace('\\', '/');
        }
        catch (Exception e){
            throw new ReviewException("이미지를 저장한 경로를 찾을 수 없습니다.", 404);
        }

        try{
            imageUrl = jdbcTemplate.queryForObject(sql, String.class, reviewId);
            imageTitle = jdbcTemplate.queryForObject(sql2, String.class, reviewId);
            urlResource = Files.readString(Paths.get(rootPath + imageUrl));
        }
        catch (Exception ex){
            throw new ReviewException("리뷰 이미지를 찾을 수 없습니다.", 404);
        }
        ReviewImageDto reviewImageDto = new ReviewImageDto(imageTitle, imageUrl, urlResource);
        return reviewImageDto;
    }

    @Override
    public void saveReviewImage(String date, int storeId, int reviewId, String reviewImage) {
        String rootPath;
        try{
            rootPath = (Paths.get("").toRealPath() + dirPath).replace('\\', '/');
        }
        catch (Exception e){
            throw new ReviewException("이미지를 저장할 경로를 찾을 수 없습니다.", 404);
        }

        String imageTitle = date.substring(0, 10) + "-" + storeId + "-" + reviewId;
        String imageUrl = validateImageUrl(rootPath, date) + "/" + imageTitle;

        try {
            File imageFile = new File(rootPath + imageUrl);
            FileOutputStream fileOutputStream = new FileOutputStream(imageFile);
            fileOutputStream.write(reviewImage.getBytes());
            fileOutputStream.close();
        }
        catch (Exception e){
            throw new ReviewException("이미지 파일을 찾을 수 없습니다.", 404);
        }
        jdbcTemplate.execute("INSERT INTO reviewImage(imageTitle, imageUrl, reviewId) VALUES('" +
                imageTitle +
                "','" + imageUrl +
                "'," + reviewId +
                ")");
    }

    @Override
    public void updateReviewImage(String date, int storeId, int reviewId, String reviewImage) {
        String rootPath;
        try{
            rootPath = (Paths.get("").toRealPath() + dirPath).replace('\\', '/');
        }
        catch (Exception e){
            throw new ReviewException("이미지를 저장할 경로를 찾을 수 없습니다.", 404);
        }

        try{
            String selectSql = "SELECT imageUrl FROM reviewImage WHERE reviewId = ?";
            String imageUrl = jdbcTemplate.queryForObject(selectSql, String.class, reviewId);
            if (imageUrl == null){
                throw new ReviewException("이미지를 저장할 경로를 찾을 수 없습니다.", 404);
            }
            Files.delete(Paths.get(rootPath + imageUrl));
        }
        catch (Exception ex){
            throw new ReviewException("삭제할 이미지를 찾을 수 없습니다.", 404);
        }

        String imageTitle = date.substring(0, 10) + "-" + storeId + "-" + reviewId;
        String imageUrl = validateImageUrl(rootPath, date) + "/" + imageTitle;
        String updateSql = "UPDATE reviewImage SET imageUrl = ?, imageTitle = ? WHERE reviewId = ?";

        try {
            File imageFile = new File(rootPath + imageUrl);
            FileOutputStream fileOutputStream = new FileOutputStream(imageFile);
            fileOutputStream.write(reviewImage.getBytes());
            fileOutputStream.close();
            jdbcTemplate.update(updateSql, imageUrl, imageTitle, reviewId);
        }
        catch (Exception e){
            throw new ReviewException("이미지 파일을 찾을 수 없습니다.", 404);
        }
    }

    @Override
    public void delReviewImage(int reviewId) {
        String selectSql = "SELECT imageUrl FROM reviewImage WHERE reviewId = ?";
        String deleteSql = "DELETE FROM reviewImage WHERE reviewId = ?";
        try{
            String imageUrl = jdbcTemplate.queryForObject(selectSql, String.class, reviewId);
            String rootPath = (Paths.get("").toRealPath() + dirPath).replace('\\', '/');
            Files.delete(Paths.get(rootPath + imageUrl));
            jdbcTemplate.update(deleteSql, reviewId);
        }
        catch (EmptyResultDataAccessException e){
            return;
        }
        catch (IOException e){
            throw new ReviewException("이미지를 저장한 경로를 찾을 수 없습니다.", 404);
        }
    }

    @Override
    public int countReview(int storeId) {
        int count = jdbcTemplate.queryForObject("SELECT count(*) FROM review WHERE storeId="+storeId, Integer.class);
        return count;
    }

    @Override
    public void validateUserId(int userId) {
        try{
            jdbcTemplate.queryForObject("SELECT userId FROM user WHERE userId="+userId, Integer.class);
        }
        catch (EmptyResultDataAccessException ex){
            throw new ReviewException("리뷰 작성 권한이 없습니다.", 403);
        }
    }

    @Override
    public String getUserName(int userId) {
        String userName;
        try{
            userName = jdbcTemplate.queryForObject("SELECT userName FROM user WHERE userId="+userId, String.class);
        }
        catch (Exception ex){
            throw new ReviewException("리뷰 작성 권한이 없습니다.", 403);
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
            throw new ReviewException("리뷰에 해당하는 가게가 존재하지 않습니다.", 404);
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

    @Override
    public String validateImageUrl(String rootPath, String date) {
        String imageUrl;

        try {
            File folder = new File(rootPath + "/reviewImage");
            if (!folder.exists()){
                folder.mkdir();
            }
            imageUrl = "/reviewImage/" + date.substring(0, 7);
            folder = new File(rootPath + imageUrl);
            if (!folder.exists()){
                folder.mkdir();
            }
        }
        catch (Exception e){
            throw new ReviewException("이미지를 저장할 경로를 찾을 수 없습니다.", 404);
        }
        return imageUrl;
    }

    @Override
    public int countReviewImage(int reviewId) {
        int count = jdbcTemplate.queryForObject("SELECT count(*) FROM reviewImage WHERE reviewId="+reviewId, Integer.class);
        return count;
    }

    @Override
    public int getStoreId(int reviewId) {
        String sql = "SELECT storeId FROM review WHERE reviewId = ?";
        int storeId;
        try{
            storeId = jdbcTemplate.queryForObject(sql, Integer.class, reviewId);
        }
        catch (EmptyResultDataAccessException ex){
            throw new ReviewException("리뷰를 작성한 가게가 존재하지 않습니다.", 404);
        }
        return storeId;
    }
}