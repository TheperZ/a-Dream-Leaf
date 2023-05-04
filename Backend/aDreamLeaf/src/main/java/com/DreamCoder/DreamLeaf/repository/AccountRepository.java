package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.AccountCreateDto;
import com.DreamCoder.DreamLeaf.dto.AccountDelDto;
import com.DreamCoder.DreamLeaf.dto.AccountDto;
import com.DreamCoder.DreamLeaf.dto.AccountUpDto;

public interface AccountRepository {
    public AccountDto save(AccountCreateDto accountCreateDto);
    public String delete(AccountDelDto accountDelDto);
    public AccountDto update(AccountUpDto accountUpDto);
}
