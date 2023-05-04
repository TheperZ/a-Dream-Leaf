package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.AccountCreateDto;
import com.DreamCoder.DreamLeaf.dto.AccountDelDto;
import com.DreamCoder.DreamLeaf.dto.AccountDto;

public interface AccountRepository {
    public AccountDto save(AccountCreateDto accountCreateDto);
    public String delete(AccountDelDto accountDelDto);
}
