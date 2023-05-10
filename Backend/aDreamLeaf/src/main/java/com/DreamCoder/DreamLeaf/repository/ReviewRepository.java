package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;

import java.util.List;

public interface ReviewRepository {
    public ReviewDto save(ReviewCreateDto reviewCreateDto);

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto);

    public String delete(ReviewDelDto reviewDelDto);

    public Integer CountReview(int storeId);

    public String findUserName(int userId);

    public String findStoreName(int storeId);

    public String update(ReviewUpDto reviewUpDto);
}
