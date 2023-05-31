package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;

import java.util.List;

public interface ReviewRepository {
    public ReviewDto save(ReviewCreateDto reviewCreateDto);

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto);

    List<ReviewDto> findAllReview(int storeId);

    public String delete(ReviewDelDto reviewDelDto);

    public int countReview(int storeId);

    public void validateUserId(int userId);

    public String getUserName(int userId);

    public String getStoreName(int storeId);

    public String update(ReviewUpDto reviewUpDto);

    public int getWriterId(int reviewId);
}
