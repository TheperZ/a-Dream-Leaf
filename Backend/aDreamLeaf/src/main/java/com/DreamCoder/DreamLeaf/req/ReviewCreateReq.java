package com.DreamCoder.DreamLeaf.req;

import lombok.Getter;

@Getter
public class ReviewCreateReq {
    private String firebaseToken;
    private int storeId;
    private String date;
    private String body;
    private int rating;
}
