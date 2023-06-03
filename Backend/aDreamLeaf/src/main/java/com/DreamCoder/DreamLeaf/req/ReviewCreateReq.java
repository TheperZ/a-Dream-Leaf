package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

@Getter
public class ReviewCreateReq {
    private String firebaseToken;
    private int storeId;
    private String date;
    private String body;
    private int rating;
}
