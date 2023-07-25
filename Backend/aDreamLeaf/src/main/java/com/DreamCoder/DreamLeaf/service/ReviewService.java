package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.repository.ReviewRepository;
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
    private final ReviewRepository reviewRepositoryImpl;

    public ReviewDto create(ReviewCreateDto reviewCreateDto) { return reviewRepositoryImpl.save(reviewCreateDto); }

    public String update(ReviewUpDto reviewUpDto) {return reviewRepositoryImpl.update(reviewUpDto);}

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto){ return reviewRepositoryImpl.findReviewPage(reviewSearchDto);}

    public List<ReviewDto> findAllReview(int storeId){ return reviewRepositoryImpl.findAllReview(storeId); }

    public String delete(ReviewDelDto reviewDelDto) {
        return reviewRepositoryImpl.delete(reviewDelDto);
    }

    public ReviewImageDto getReviewImage(int reviewId) { return reviewRepositoryImpl.getReviewImage(reviewId); }
}