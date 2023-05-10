package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class AccountUpReq {
    private int accountId;
    private String restaurant;
    private int price;
    private String date;
    private String body;
    private String firebaseToken;
}
