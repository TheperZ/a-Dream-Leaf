package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;

public interface ReviewRepository {
    public ReviewDto save(ReviewCreateDto reviewCreateDto);
}
