package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;

public interface ReviewRepository {
    public ReviewDto save(ReviewCreateDto reviewCreateDto);
    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto);
    List<ReviewDto> findAllReview(int storeId);
    public String delete(ReviewDelDto reviewDelDto);
    public String update(ReviewUpDto reviewUpDto);
    public ReviewImageDto getReviewImage(int reviewId);
    public void saveReviewImage(String date, int storeId, int reviewId, String reviewImage);
    public void updateReviewImage(String date, int storeId, int reviewId, String reviewImage);
    public void delReviewImage(int reviewId);
    public int countReview(int storeId);
    public void validateUserId(int userId);
    public String getUserName(int userId);
    public String getStoreName(int storeId);
    public int getWriterId(int reviewId);
    public String validateImageUrl(String rootPath, String date);
    public int countReviewImage(int reviewId);
    public int getStoreId(int reviewId);
}
