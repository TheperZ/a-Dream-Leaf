package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.AccountCreateReq;
import com.DreamCoder.DreamLeaf.req.AccountDelReq;
import com.DreamCoder.DreamLeaf.req.AccountSetReq;
import com.DreamCoder.DreamLeaf.req.AccountUpReq;
import com.DreamCoder.DreamLeaf.service.AccountService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

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
    public ResponseEntity deleteAccount(@RequestBody AccountDelReq accountDelReq) throws FirebaseAuthException{
        String firebaseToken = accountDelReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountDelDto accountDelDto = new AccountDelDto(id, accountDelReq.getAccountId());
        String result = accountService.delete(accountDelDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/account/update")
    public ResponseEntity updateAccount(@RequestBody AccountUpReq accountUpReq) throws FirebaseAuthException{
        String firebaseToken = accountUpReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountUpDto accountUpDto = new AccountUpDto(accountUpReq.getAccountId(), accountUpReq.getRestaurant(), accountUpReq.getPrice(), accountUpReq.getDate(), accountUpReq.getBody(), id);
        AccountDto result = accountService.update(accountUpDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/account/list")
    public ResponseEntity getAccountList(){
        return null;
    }

    @PostMapping("/account")
    public ResponseEntity getSimpleAccount(@RequestBody Map<String,String> req) throws FirebaseAuthException{
        String firebaseToken = req.get("firebaseToken");
        int id = authUtil.findUserId(firebaseToken);
        SimpleAccountDto simpleAccountDto = accountService.simpleInquire(id);
        return ResponseEntity.ok().body(simpleAccountDto);
    }

    @PostMapping("/account/setting")
    public ResponseEntity settingAccount(@RequestBody AccountSetReq accountSetReq) throws FirebaseAuthException{
        String firebaseToken = accountSetReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountSetDto accountSetDto = new AccountSetDto(id,accountSetReq.getAmount());
        String result = accountService.setAccount(accountSetDto);
        return ResponseEntity.ok().body(result);
    }
}
