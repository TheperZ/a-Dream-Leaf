package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.repository.ReviewRepository;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepositoryImpl;

    public ReviewDto create(ReviewCreateDto reviewCreateDto) { return reviewRepositoryImpl.save(reviewCreateDto); }

    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto) { return reviewRepositoryImpl.findReviewPage(reviewSearchDto);}

    public String update(ReviewUpDto reviewUpDto) {return reviewRepositoryImpl.update(reviewUpDto);}

    public String delete(ReviewDelDto reviewDelDto) {
        return reviewRepositoryImpl.delete(reviewDelDto);
    }

    public ReviewImageDto getReviewImage(int reviewId) { return reviewRepositoryImpl.getReviewImage(reviewId); }
}