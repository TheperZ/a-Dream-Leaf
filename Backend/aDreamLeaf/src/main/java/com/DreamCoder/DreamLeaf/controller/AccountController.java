package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.req.AccountCreateReq;
import com.DreamCoder.DreamLeaf.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

    @PostMapping("/account/create")
    public ResponseEntity createAccount(@RequestBody AccountCreateReq accountCreateReq){
        
        return null;
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
