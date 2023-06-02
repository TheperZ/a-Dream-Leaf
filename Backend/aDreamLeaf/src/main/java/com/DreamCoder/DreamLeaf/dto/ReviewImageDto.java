package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.core.io.UrlResource;

@Getter
@AllArgsConstructor
public class ReviewImageDto {
    private String imageTitle;
    private String imageUrl;
    UrlResource urlResource;
}
