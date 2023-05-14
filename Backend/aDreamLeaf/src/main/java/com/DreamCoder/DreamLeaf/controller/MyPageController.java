package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import com.DreamCoder.DreamLeaf.req.MyPageDelReq;
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

@RestController
@Slf4j
@RequiredArgsConstructor
public class MyPageController {

    @Autowired
    private final MyPageService myPageService;
    private final AuthUtil authUtil;

    @PostMapping("/myPage/delete")
    public ResponseEntity deleteMyPage(@RequestBody MyPageDelReq myPageDelReq) throws FirebaseAuthException{
        String firebaseToken = myPageDelReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        String newId = Integer.toString(id);
        MyPageDelDto myPageDelDto = new MyPageDelDto(newId);
        String result = myPageService.delete(myPageDelDto);
        return ResponseEntity.ok().body(result);
    }

}
