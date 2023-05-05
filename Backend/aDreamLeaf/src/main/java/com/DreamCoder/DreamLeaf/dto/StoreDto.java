package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
@AllArgsConstructor
@ToString
@Builder
public class StoreDto {
    private int storeId;
    private String storeName;
    private int zipCode;
    private String roadAddr;
    private String lotAddr;
    private double wgs84Lat;
    private double wgs84Logt;
    private boolean payment;
    private String prodName;
    private String prodTarget;
}
