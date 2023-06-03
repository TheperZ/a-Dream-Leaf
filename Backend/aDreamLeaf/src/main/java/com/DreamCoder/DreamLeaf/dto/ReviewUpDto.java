package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@AllArgsConstructor
public class ReviewUpDto {
    private int userId;
    private int reviewId;
    private String date;
    private String body;
    private int rating;
    private MultipartFile reviewImage;

    public ReviewUpDto(int userId, int reviewId, String date, String body, int rating) {
        this.userId = userId;
        this.reviewId = reviewId;
        this.date = date;
        this.body = body;
        this.rating = rating;
    }

    public void setReviewImage(MultipartFile reviewImage) {
        this.reviewImage = reviewImage;
    }
}
