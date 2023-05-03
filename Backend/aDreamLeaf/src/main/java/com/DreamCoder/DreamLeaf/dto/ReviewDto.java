package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReviewDto {
    private int userId;
    private String userName;
    private int reviewId;
    private int storeId;
    private String storeName;
    private String date;
    private String body;
    private int rating;

    public ReviewDto(int userId, int reviewId, int storeId, String date, String body, int rating) {
        this.userId = userId;
        this.reviewId = reviewId;
        this.storeId = storeId;
        this.date = date;
        this.body = body;
        this.rating = rating;
    }

    public void setNameData(String userName, String storeName){
        this.userName = userName;
        this.storeName = storeName;
    }
}
