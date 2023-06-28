package com.DreamCoder.DreamLeaf.req;

import lombok.Getter;

import java.util.Optional;

@Getter
public class ReviewUpReq {
    private String firebaseToken;
    private int reviewId;
    private String date;
    private String body;
    private int rating;
    private Optional<String> reviewImage;
}
