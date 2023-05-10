package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;
import com.DreamCoder.DreamLeaf.dto.ReviewPagination;
import com.DreamCoder.DreamLeaf.dto.ReviewSearchDto;
import com.DreamCoder.DreamLeaf.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepositoryImpl;

    public ReviewDto create(ReviewCreateDto reviewCreateDto){
        return reviewRepositoryImpl.save(reviewCreateDto);
    }

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto){
        Integer count = reviewRepositoryImpl.CountReview(reviewSearchDto.getStoreId());

        if(count != null){
            reviewSearchDto.setReviewPagination(new ReviewPagination(count, reviewSearchDto));
        }

        List<ReviewDto> reviewDtoList = reviewRepositoryImpl.findReviewPage(reviewSearchDto);
        return reviewDtoList;
    }
}
