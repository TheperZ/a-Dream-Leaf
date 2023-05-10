package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Setter;

@Data
@AllArgsConstructor
@Builder
public class AccountListResultDto {

    public void setRemain(int remain) {
        this.remain = remain;
    }

    private int accountId;
    private String restaurant;
    private int price;
    private String date;
    private String body;
    private int userId;
    private int remain; // 잔액
}
