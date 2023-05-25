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
import java.util.HashSet;

@RestController
@Slf4j
@RequiredArgsConstructor
public class SignUpController {

    @Autowired
    private final SignUpService signUpService;
    private final AuthUtil authUtil;

    private HashSet<String> usedUserNames = new HashSet<>();

    @PostMapping("/login/signUp")      // 회원가입
    public ResponseEntity createSignUp(@RequestBody SignUpCreateReq signUpCreateReq) throws FirebaseAuthException {
        String firebaseToken = signUpCreateReq.getFirebaseToken();
        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseToken);
        String uid = decodedToken.getUid();

        String userName = generateUniqueUserName();
        while (usedUserNames.contains(userName)) {
            userName = generateUniqueUserName();
        }

        SignUpCreateDto signUpCreateDto = new SignUpCreateDto(userName, signUpCreateReq.getEmail(), uid);
        String result = signUpService.create(signUpCreateDto);

        usedUserNames.add(userName);

        return ResponseEntity.ok().body(result);
    }

    private String generateUniqueUserName() {
        String[] a = {"행복한", "뛰어난", "엄청난", "헤엄치는", "날아다니는", "귀여운", "미소짓는", "탐스러운", "말랑말랑한", "개구진",
                "강력한", "우아한", "떠오르는", "활발한", "씩씩한", "튼튼한", "시원한", "빛나는", "상쾌한", "기다란",
                "말끔한", "너그러운", "네모난", "동그란", "부드러운", "쏜살같은", "점잖은", "즐거운", "지혜로운", "희망찬"};
        String[] b = {"강아지", "고양이", "돌고래", "너구리", "조랑말", "치타", "미어캣", "물고기", "사자", "호랑이",
                "물소", "공룡", "물소", "맘모스", "기린", "곰", "거북이", "꽃사슴", "판다", "염소",
                "개구리", "고릴라", "코뿔소", "고슴도치", "하마", "수달", "해달", "낙타", "양", "코끼리"};
        Random random = new Random();
        String user = a[random.nextInt(a.length)] + " " + b[random.nextInt(b.length)];

        return user;
    }

    @PostMapping("/login")             // 로그인
    public ResponseEntity getLogin(@RequestBody Map<String,String> req) throws FirebaseAuthException{
        String firebaseToken = req.get("firebaseToken");
        int id = authUtil.findUserId(firebaseToken);
        LoginDto loginDto = signUpService.loginInquire(id);
        return ResponseEntity.ok().body(loginDto);
    }
}