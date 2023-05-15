package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;
import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import com.DreamCoder.DreamLeaf.dto.LoginDto;
import com.DreamCoder.DreamLeaf.req.SignUpCreateReq;
import com.DreamCoder.DreamLeaf.req.LoginReq;
import com.DreamCoder.DreamLeaf.service.SignUpService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import java.util.Map;
import java.util.Random;

@RestController
@Slf4j
@RequiredArgsConstructor
public class SignUpController {

    @Autowired
    private final SignUpService signUpService;
    private final AuthUtil authUtil;


    @PostMapping("/login/signUp")      // 회원가입
    public ResponseEntity createSignUp(@RequestBody SignUpCreateReq signUpCreateReq) throws FirebaseAuthException {
        String firebaseToken = signUpCreateReq.getFirebaseToken();
        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseToken);
        String uid = decodedToken.getUid();
        String[] a = {"good", "brilliant", "great", "excellent", "happy"}; // 닉네임 임의 부여 조합 예시
        String[] b = {"dog", "cat", "dolphin", "racoon", "horse"};
        Random random = new Random();
        String userName = a[random.nextInt(a.length)] + " " + b[random.nextInt(b.length)];
        SignUpCreateDto signUpCreateDto = new SignUpCreateDto(userName, signUpCreateReq.getEmail(), uid);
        /*SignUpDto signUpDto = signUpService.create(signUpCreateDto);
        return ResponseEntity.status(201).body(signUpDto);*/
        String result = signUpService.create(signUpCreateDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/login")             // 로그인
    public ResponseEntity getLogin(@RequestBody LoginReq loginReq) throws FirebaseAuthException{
        String firebaseToken = loginReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        String newId = Integer.toString(id);
        LoginDto loginDto = signUpService.loginInquire(newId);
        return ResponseEntity.ok().body(loginDto);
    }
}