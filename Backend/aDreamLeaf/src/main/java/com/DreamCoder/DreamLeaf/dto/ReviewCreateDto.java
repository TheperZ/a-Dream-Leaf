package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ReviewCreateDto {
    private String storeId;
    private String date;
    private String body;
    private int rating;
    private int userId;
}
