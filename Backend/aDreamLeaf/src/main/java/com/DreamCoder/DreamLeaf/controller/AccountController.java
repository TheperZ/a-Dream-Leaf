package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.AccountCreateDto;
import com.DreamCoder.DreamLeaf.dto.AccountDto;
import com.DreamCoder.DreamLeaf.req.AccountCreateReq;
import com.DreamCoder.DreamLeaf.service.AccountService;
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
public class AccountController {

    @Autowired
    private final AccountService accountService;
    private final AuthUtil authUtil;

    @PostMapping("/account/create")
    public ResponseEntity createAccount(@RequestBody AccountCreateReq accountCreateReq) throws FirebaseAuthException {
        String firebaseToken = accountCreateReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountCreateDto accountCreateDto = new AccountCreateDto(accountCreateReq.getRestaurant(), accountCreateReq.getPrice(), accountCreateReq.getDate(), accountCreateReq.getBody(), id);
        AccountDto accountDto = accountService.create(accountCreateDto);
        return ResponseEntity.status(201).body(accountDto);
    }

    @PostMapping("/account/delete")
    public ResponseEntity deleteAccount(){
        return null;
    }

    @PostMapping("/account/update")
    public ResponseEntity updateAccount(){
        return null;
    }

    @PostMapping("/account/list")
    public ResponseEntity getAccountList(){
        return null;
    }

    @PostMapping("/account")
    public ResponseEntity getSimpleAccount(){
        return null;
    }

    @PostMapping("/account/setting")
    public ResponseEntity settingAccount(){
        return null;
    }
}