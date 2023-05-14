package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.MyPageDto;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import com.DreamCoder.DreamLeaf.req.MyPageDelReq;
import com.DreamCoder.DreamLeaf.req.MyPageReq;
import com.DreamCoder.DreamLeaf.service.MyPageService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
public class MyPageController {

    @Autowired
    private final MyPageService myPageService;
    private final AuthUtil authUtil;

    @PostMapping("/myPage/delete")          // 사용자 계정 삭제
    public ResponseEntity deleteMyPage(@RequestBody MyPageDelReq myPageDelReq) throws FirebaseAuthException{
        String firebaseToken = myPageDelReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        String newId = Integer.toString(id);
        MyPageDelDto myPageDelDto = new MyPageDelDto(newId);
        String result = myPageService.delete(myPageDelDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/myPage")                 // 현재 사용자 데이터 조회
    public ResponseEntity getMyPage(@RequestBody MyPageReq myPageReq) throws FirebaseAuthException{
        String firebaseToken = myPageReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        String newId = Integer.toString(id);
        MyPageDto myPageDto = myPageService.myPageInquire(newId);
        return ResponseEntity.ok().body(myPageDto);
    }

}
