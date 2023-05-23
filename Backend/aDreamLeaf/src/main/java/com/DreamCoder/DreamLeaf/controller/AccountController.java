package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.*;
import com.DreamCoder.DreamLeaf.req.*;
import com.DreamCoder.DreamLeaf.service.AccountService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
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
        String result = accountService.update(accountUpDto);
        return ResponseEntity.ok().body(result);
    }

    @PostMapping("/account/list")
    public ResponseEntity getAccountList(@RequestBody AccountListReq accountListReq) throws FirebaseAuthException{
        String firebaseToken = accountListReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountListDto accountListDto = new AccountListDto(id,accountListReq.getYearMonth());
        List<AccountListResultDto> results = accountService.readAccount(accountListDto);
        return ResponseEntity.ok().body(results);
    }

    @PostMapping("/account")
    public ResponseEntity getSimpleAccount(@RequestBody AccountInqReq accountInqReq) throws FirebaseAuthException{
        String firebaseToken = accountInqReq.getFirebaseToken();
        int id = authUtil.findUserId(firebaseToken);
        AccountInqDto accountInqDto = new AccountInqDto(id,accountInqReq.getYearMonth());
        SimpleAccountDto simpleAccountDto = accountService.simpleInquire(accountInqDto);
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
