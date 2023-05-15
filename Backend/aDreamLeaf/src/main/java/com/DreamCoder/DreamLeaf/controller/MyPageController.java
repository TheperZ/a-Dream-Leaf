package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.MyPageDto;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import com.DreamCoder.DreamLeaf.req.MyPageDelReq;
import com.DreamCoder.DreamLeaf.req.MyPageReq;
import com.DreamCoder.DreamLeaf.service.MyPageService;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
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
    public ResponseEntity deleteMyPage(@RequestBody Map<String,String> req) throws FirebaseAuthException{
        String firebaseToken = req.get("firebaseToken");
        int id = authUtil.findUserId(firebaseToken);
        MyPageDelDto myPageDelDto = new MyPageDelDto(id);
        String result = myPageService.delete(myPageDelDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/myPage")                 // 현재 사용자 데이터 조회
    public ResponseEntity getMyPage(@RequestBody Map<String,String> req) throws FirebaseAuthException{
        String firebaseToken = req.get("firebaseToken");
        int id = authUtil.findUserId(firebaseToken);
        MyPageDto myPageDto = myPageService.myPageInquire(id);
        return ResponseEntity.ok().body(myPageDto);
    }

}
