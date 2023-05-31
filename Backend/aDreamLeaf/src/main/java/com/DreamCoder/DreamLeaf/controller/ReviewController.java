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
import com.DreamCoder.DreamLeaf.req.ReviewCreateReq;
import com.DreamCoder.DreamLeaf.req.ReviewDelReq;
import com.DreamCoder.DreamLeaf.req.ReviewSearchReq;
import com.DreamCoder.DreamLeaf.req.ReviewUpReq;
import com.DreamCoder.DreamLeaf.service.ReviewService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.repository.query.Param;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;
    private final AuthUtil authUtil;

    @PostMapping("/review/create")
    public ResponseEntity createReview(@RequestBody ReviewCreateReq reviewCreateReq) throws FirebaseAuthException{
        String firebaseToken = reviewCreateReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewCreateDto reviewCreateDto = new ReviewCreateDto(reviewCreateReq.getStoreId(), reviewCreateReq.getDate(), reviewCreateReq.getBody(), reviewCreateReq.getRating(), id);
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
    @PostMapping("/review/update")
    public ResponseEntity updateReview(@RequestBody ReviewUpReq reviewUpReq) throws FirebaseAuthException{
        String firebaseToken = reviewUpReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);

        ReviewUpDto reviewUpDto = new ReviewUpDto(id, reviewUpReq.getReviewId(), reviewUpReq.getDate(), reviewUpReq.getBody(), reviewUpReq.getRating());
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
}
