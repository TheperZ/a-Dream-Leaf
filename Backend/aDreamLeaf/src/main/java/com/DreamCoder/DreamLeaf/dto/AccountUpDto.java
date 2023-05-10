package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class AccountUpDto {
    private int accountId;
    private String restaurant;
    private int price;
    private String date;
    private String body;
    private int userId;
}
