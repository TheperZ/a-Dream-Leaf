package com.DreamCoder.DreamLeaf.req;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@Getter
@ToString
public class ReviewCreateReq {
    private String firebaseToken;
    private int storeId;
    private String date;
    private String body;
    private int rating;
    private Optional<String> reviewImage;
}
