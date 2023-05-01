package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AccountController {

    @Autowired
    private final AccountService accountService;


}
