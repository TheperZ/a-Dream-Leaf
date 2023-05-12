package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;
import com.DreamCoder.DreamLeaf.dto.ReviewSearchDto;

import java.util.List;

public interface ReviewRepository {
    public ReviewDto save(ReviewCreateDto reviewCreateDto);

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto);

    public Integer CountReview(int storeId);

    public String findUserName(int userId);

    public String findStoreName(int storeId);
}
