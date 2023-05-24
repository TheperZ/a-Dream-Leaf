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
    private int storeId;
    private String storeName;
    private int storeType;
    private double curDist;
    private double totalRating;
}
