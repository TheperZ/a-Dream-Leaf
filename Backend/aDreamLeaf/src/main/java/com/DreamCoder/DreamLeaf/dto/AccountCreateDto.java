package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@Getter
@Builder
public class AccountCreateDto {
    private String restaurant;
    private int price;
    private String date;
    private String body;
    private int userId;
}
