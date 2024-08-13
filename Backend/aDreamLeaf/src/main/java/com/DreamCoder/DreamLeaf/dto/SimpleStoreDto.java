package com.DreamCoder.DreamLeaf.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
@AllArgsConstructor
@ToString
@Builder
public class SimpleStoreDto {
    private Long storeId;
    private String storeName;
    private int storeType;
    @Builder.Default
    private double curDist = 0;
    private double totalRating;
}
