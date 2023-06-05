package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@Getter
@AllArgsConstructor
public class ReviewUpDto {
    private int userId;
    private int reviewId;
    private String date;
    private String body;
    private int rating;
    private Optional<MultipartFile> reviewImage;
}
