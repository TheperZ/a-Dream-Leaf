package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

@AllArgsConstructor
@Getter
public class ReviewCreateDto {
    private int storeId;
    private String date;
    private String body;
    private int rating;
    private int userId;
    private MultipartFile reviewImage;

    public ReviewCreateDto(int storeId, String date, String body, int rating, int userId) {
        this.storeId = storeId;
        this.date = date;
        this.body = body;
        this.rating = rating;
        this.userId = userId;
    }

    public void setReviewImage(MultipartFile reviewImage){
        this.reviewImage = reviewImage;
    }
}
