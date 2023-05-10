package com.DreamCoder.DreamLeaf.dto;

import lombok.Getter;

@Getter
public class ReviewSearchDto {
    private int storeId;
    private int page;
    private int display;
    private ReviewPagination reviewPagination;

    public ReviewSearchDto(int storeId, int page, int display) {
        this.storeId = storeId;
        this.page = page;
        this.display = display;
    }

    public void setReviewPagination(ReviewPagination reviewPagination) {
        this.reviewPagination = reviewPagination;
    }
}
