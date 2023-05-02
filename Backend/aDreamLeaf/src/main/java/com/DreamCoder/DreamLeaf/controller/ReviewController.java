package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;
import com.DreamCoder.DreamLeaf.req.ReviewCreateReq;
import com.DreamCoder.DreamLeaf.service.ReviewService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;
    private final AuthUtil authUtil;

    @PostMapping("/review/create")
    public ResponseEntity createReview(@RequestBody ReviewCreateReq reviewCreateReq) throws FirebaseAuthException {

        String firebaseToken = reviewCreateReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        ReviewCreateDto reviewCreateDto = new ReviewCreateDto(reviewCreateReq.getStoreId(), reviewCreateReq.getDate(), reviewCreateReq.getBody(), reviewCreateReq.getRating(), id);
        ReviewDto reviewDto = reviewService.create(reviewCreateDto);
        return ResponseEntity.status(201).body(reviewDto);
    }
}
