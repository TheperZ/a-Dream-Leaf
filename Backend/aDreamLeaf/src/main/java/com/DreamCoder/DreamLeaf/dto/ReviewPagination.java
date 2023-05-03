package com.DreamCoder.DreamLeaf.dto;

import lombok.Getter;

@Getter
public class ReviewPagination {
    private int totalReviewCount;
    private int totalPageCount;
    private int limitStart;

    public ReviewPagination(int totalReviewCount, ReviewSearchDto reviewSearchDto) {
        if (totalReviewCount > 0){
            this.totalReviewCount = totalReviewCount;
            calculation(reviewSearchDto);
        }
    }

    private void calculation(ReviewSearchDto reviewSearchDto){
        totalPageCount = ((totalReviewCount - 1) / reviewSearchDto.getDisplay()) + 1;
        limitStart = reviewSearchDto.getDisplay() * (reviewSearchDto.getPage() - 1);
    }
}
