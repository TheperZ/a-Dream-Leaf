package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

import java.time.LocalDate;


@Data
@AllArgsConstructor
@Getter
@ToString
@Builder
public class AccountDto {
    private int accountId;
    private String restaurant;
    private int price;
    private String date;
    private String body;
    private int userId;
}
