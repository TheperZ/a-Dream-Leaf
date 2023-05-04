package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;

public interface AccountRepository {
    public AccountDto save(AccountCreateDto accountCreateDto);
    public String delete(AccountDelDto accountDelDto);
    public AccountDto update(AccountUpDto accountUpDto);
    public SimpleAccountDto inquire(int id);
    public String set(AccountSetDto accountSetDto);
}
