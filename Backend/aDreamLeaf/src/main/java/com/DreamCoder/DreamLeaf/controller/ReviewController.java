package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.ReviewCreateReq;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import com.DreamCoder.DreamLeaf.req.ReviewSearchReq;
import com.DreamCoder.DreamLeaf.req.ReviewUpReq;
import com.DreamCoder.DreamLeaf.service.ReviewService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.UrlResource;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Optional;

@RestController
@Slf4j
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;
    private final AuthUtil authUtil;


    @PostMapping(path = "/review/create", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity createReview(@RequestPart(name = "reviewBody") ReviewCreateReq reviewCreateReq, @RequestPart Optional<MultipartFile> reviewImage) throws FirebaseAuthException{
        String firebaseToken = reviewCreateReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewCreateDto reviewCreateDto = new ReviewCreateDto(reviewCreateReq.getStoreId(), reviewCreateReq.getDate(), reviewCreateReq.getBody(), reviewCreateReq.getRating(), id, reviewImage);
        ReviewDto reviewDto = reviewService.create(reviewCreateDto);
        return ResponseEntity.status(201).body(reviewDto);
    }

    @GetMapping(path = "/review/{storeId}")
    public ResponseEntity getReviewList(@PathVariable(name = "storeId") int storeId, @Param(value = "reviewSearchReq") ReviewSearchReq reviewSearchReq){
        List<ReviewDto> reviewDtoList;
        if (reviewSearchReq.getPage() == 0 && reviewSearchReq.getDisplay() == 0){
            reviewDtoList = reviewService.findAllReview(storeId);
        }
        else{
            ReviewSearchDto reviewSearchDto = new ReviewSearchDto(storeId, reviewSearchReq.getPage(), reviewSearchReq.getDisplay());
            reviewDtoList = reviewService.findReviewPage(reviewSearchDto);
        }

        return ResponseEntity.ok().body(reviewDtoList);
    }
    @PostMapping(path = "/review/update", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity updateReview(@RequestPart(name = "reviewPost") ReviewUpReq reviewUpReq, @RequestPart("reviewImage") Optional<MultipartFile> reviewImage) throws FirebaseAuthException{
        String firebaseToken = reviewUpReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewUpDto reviewUpDto = new ReviewUpDto(id, reviewUpReq.getReviewId(), reviewUpReq.getDate(), reviewUpReq.getBody(), reviewUpReq.getRating(), reviewImage);
        String result = reviewService.update(reviewUpDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/review/delete")
    public ResponseEntity deleteReview(@RequestBody ReviewDelReq reviewDelReq) throws FirebaseAuthException{
        String firebaseToken = reviewDelReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewDelDto reviewDelDto = new ReviewDelDto(id, reviewDelReq.getReviewId());
        String result = reviewService.delete(reviewDelDto);
        return ResponseEntity.ok().body(result);
    }

    @GetMapping("/review/{reviewId}/image")
    public ResponseEntity<UrlResource> getReviewImage(@PathVariable(name="reviewId") int reviewId){
        ReviewImageDto reviewImageDto = reviewService.getReviewImage(reviewId);
        String contentDisposition = "attachment; filename=\"" + reviewImageDto.getImageTitle() + '"';
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
                .body(reviewImageDto.getUrlResource());
    }
}
