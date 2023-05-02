package com.DreamCoder.DreamLeaf.req;

import lombok.Data;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDate;

@Data
@Getter
@ToString
public class AccountCreateReq {
    private String firebaseToken;
    private String restaurant;
    private int price;
    private String date;
    private String body;
}
