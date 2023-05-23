package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.*;

import java.util.List;

public interface AccountRepository {
    public AccountDto save(AccountCreateDto accountCreateDto);
    public String delete(AccountDelDto accountDelDto);
    public String update(AccountUpDto accountUpDto);
    public SimpleAccountDto inquire(AccountInqDto accountInqDto);
    public String set(AccountSetDto accountSetDto);
    public List<AccountListResultDto> search(AccountListDto accountListDto);
    public int getRemain(int userId,String startDate, String endDate);
    public int getAmount(int userId,String startDate, String endDate);
    public String getCreatedDate(int accountId);
    public int getPrice(int accountId);
    public int getWriteId(int accountId);
}
