package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.AccountCreateDto;
import com.DreamCoder.DreamLeaf.dto.AccountDto;
import com.DreamCoder.DreamLeaf.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class AccountService {

    private final AccountRepository AccountRepositoryImpl;

    public AccountDto create(AccountCreateDto accountCreateDto){
        return AccountRepositoryImpl.save(accountCreateDto);
    }

}
