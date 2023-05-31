//package com.DreamCoder.DreamLeaf.controller;
//
//import com.DreamCoder.DreamLeaf.Util.AuthUtil;
//import com.DreamCoder.DreamLeaf.dto.*;
//import com.DreamCoder.DreamLeaf.req.ReviewCreateReq;
//import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
//import com.DreamCoder.DreamLeaf.req.ReviewSearchReq;
//import com.DreamCoder.DreamLeaf.req.ReviewUpReq;
//import com.DreamCoder.DreamLeaf.service.ReviewService;
//import com.google.firebase.auth.FirebaseAuthException;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.repository.query.Param;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@Slf4j
//@RequiredArgsConstructor
//public class ReviewController {
//
//    private final ReviewService reviewService;
//    private final AuthUtil authUtil;
//
//    @PostMapping("/review/create")
//    public ResponseEntity createReview(@RequestBody ReviewCreateReq reviewCreateReq) throws FirebaseAuthException {
//
//        String firebaseToken = reviewCreateReq.getFirebaseToken();
//        int id = authUtil.findUserId(firebaseToken);
//
//        ReviewCreateDto reviewCreateDto = new ReviewCreateDto(reviewCreateReq.getStoreId(), reviewCreateReq.getDate(), reviewCreateReq.getBody(), reviewCreateReq.getRating(), id);
//        ReviewDto reviewDto = reviewService.create(reviewCreateDto);
//        return ResponseEntity.status(201).body(reviewDto);
//    }
//
//    @GetMapping(path = "/review/{storeId}")
//    public ResponseEntity getReviewList(@PathVariable(name = "storeId") int storeId, @Param(value = "reviewSearchReq") ReviewSearchReq reviewSearchReq){
//
//        ReviewSearchDto reviewSearchDto = new ReviewSearchDto(storeId, reviewSearchReq.getPage(), reviewSearchReq.getDisplay());
//
//        List<ReviewDto> reviewDtoList = reviewService.findReviewPage(reviewSearchDto);
//        return ResponseEntity.status(200).body(reviewDtoList);
//    }
//
//    @PostMapping("/review/update")
//    public ResponseEntity updateReview(@RequestBody ReviewUpReq reviewUpReq) throws FirebaseAuthException{
//
//        String firebaseToken = reviewUpReq.getFirebaseToken();
//        int id = authUtil.findUserId(firebaseToken);
//
//        ReviewUpDto reviewUpDto = new ReviewUpDto(id, reviewUpReq.getReviewId(), reviewUpReq.getDate(), reviewUpReq.getBody(), reviewUpReq.getRating());
//        String result = reviewService.update(reviewUpDto);
//        return ResponseEntity.status(200).body(result);
//    }
//
//    @PostMapping("/review/delete")
//    public ResponseEntity deleteReview(@RequestBody ReviewDelReq reviewDelReq) throws FirebaseAuthException{
//
//        String firebaseToken = reviewDelReq.getFirebaseToken();
//        int id = authUtil.findUserId(firebaseToken);
//
//        ReviewDelDto reviewDelDto = new ReviewDelDto(id, reviewDelReq.getReviewId());
//        String result = reviewService.delete(reviewDelDto);
//        return ResponseEntity.status(204).body(result);
//    }
//}

package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.exception.ReviewException;
import com.DreamCoder.DreamLeaf.req.ReviewCreateReq;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import com.DreamCoder.DreamLeaf.req.ReviewSearchReq;
import com.DreamCoder.DreamLeaf.req.ReviewUpReq;
import com.DreamCoder.DreamLeaf.service.ReviewService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.UrlResource;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;
    private final AuthUtil authUtil;


    @PostMapping("/review/create")
    public ResponseEntity createReview(@RequestParam("reviewBody") String reviewBody, @RequestPart("reviewImage") MultipartFile reviewImage) throws FirebaseAuthException{
        ObjectMapper objectMapper = new ObjectMapper();
        ReviewCreateReq reviewCreateReq;
        try{
            reviewCreateReq = objectMapper.readValue(reviewBody, ReviewCreateReq.class);
        }
        catch (Exception e){
            throw new ReviewException("잘못된 형식의 요청입니다.", 400);
        }

        String firebaseToken = reviewCreateReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        ReviewCreateDto reviewCreateDto = new ReviewCreateDto(reviewCreateReq.getStoreId(), reviewCreateReq.getDate(), reviewCreateReq.getBody(), reviewCreateReq.getRating(), id);
        if (reviewImage != null && !reviewImage.isEmpty())
            reviewCreateDto.setReviewImage(reviewImage);

        ReviewDto reviewDto = reviewService.create(reviewCreateDto);
        return ResponseEntity.status(201).body(reviewDto);
    }

    @GetMapping(path = "/review/{storeId}")
    public ResponseEntity getReviewList(@PathVariable(name = "storeId") int storeId, @Param(value = "reviewSearchReq") ReviewSearchReq reviewSearchReq){
        ReviewSearchDto reviewSearchDto = new ReviewSearchDto(storeId, reviewSearchReq.getPage(), reviewSearchReq.getDisplay());

        List<ReviewDto> reviewDtoList = reviewService.findReviewPage(reviewSearchDto);
        return ResponseEntity.ok().body(reviewDtoList);
    }

    @PostMapping("/review/update")
    public ResponseEntity updateReview(@RequestParam("reviewPost") String reviewPost, @RequestPart("reviewImage") MultipartFile reviewImage) throws FirebaseAuthException{
        ObjectMapper objectMapper = new ObjectMapper();
        ReviewUpReq reviewUpReq;
        try{
            reviewUpReq = objectMapper.readValue(reviewPost, ReviewUpReq.class);
        }
        catch (Exception e){
            throw new ReviewException("잘못된 형식의 요청입니다.", 400);
        }

        String firebaseToken = reviewUpReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewUpDto reviewUpDto = new ReviewUpDto(id, reviewUpReq.getReviewId(), reviewUpReq.getDate(), reviewUpReq.getBody(), reviewUpReq.getRating());

        if (reviewImage != null && !reviewImage.isEmpty())
            reviewUpDto.setReviewImage(reviewImage);

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
