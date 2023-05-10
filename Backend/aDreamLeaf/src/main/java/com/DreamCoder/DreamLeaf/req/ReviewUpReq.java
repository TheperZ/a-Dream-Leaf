package com.DreamCoder.DreamLeaf.req;

import lombok.Getter;

@Getter
public class ReviewUpReq {
    private String firebaseToken;
    private int reviewId;
    private String date;
    private String body;
    private int rating;
}
