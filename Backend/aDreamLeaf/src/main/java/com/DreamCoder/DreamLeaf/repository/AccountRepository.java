package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;

import java.util.List;

public interface AccountRepository {
    public AccountDto save(AccountCreateDto accountCreateDto);
    public String delete(AccountDelDto accountDelDto);
    public String update(AccountUpDto accountUpDto);
    public SimpleAccountDto inquire(int id);
    public String set(AccountSetDto accountSetDto);
    public List<AccountListResultDto> search(AccountListDto accountListDto);
}
