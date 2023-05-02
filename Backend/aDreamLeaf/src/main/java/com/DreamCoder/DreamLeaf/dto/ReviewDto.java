package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ReviewDto {
    private int reviewId;
    private int storeId;
    private int userId;
    private String date;
    private String body;
    private int rating;
}
