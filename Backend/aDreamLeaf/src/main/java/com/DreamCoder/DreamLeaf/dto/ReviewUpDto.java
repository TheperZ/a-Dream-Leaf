package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReviewUpDto {
    private int userId;
    private int reviewId;
    private String date;
    private String body;
    private int rating;
}
