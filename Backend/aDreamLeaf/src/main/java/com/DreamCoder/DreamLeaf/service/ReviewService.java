package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.repository.ReviewRepositoryCustom;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReviewService {

    @Autowired
    private final ReviewRepositoryCustom reviewRepositoryCustomImpl;

    public ReviewDto create(ReviewCreateDto reviewCreateDto) { return reviewRepositoryCustomImpl.save(reviewCreateDto); }

    public String update(ReviewUpDto reviewUpDto) {return reviewRepositoryCustomImpl.update(reviewUpDto);}

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto){ return reviewRepositoryCustomImpl.findReviewPage(reviewSearchDto);}

    public List<ReviewDto> findAllReview(int storeId){ return reviewRepositoryCustomImpl.findAllReview(storeId); }

    public String delete(ReviewDelDto reviewDelDto) {
        return reviewRepositoryCustomImpl.delete(reviewDelDto);
    }

    public ReviewImageDto getReviewImage(int reviewId) { return reviewRepositoryCustomImpl.getReviewImage(reviewId); }
}