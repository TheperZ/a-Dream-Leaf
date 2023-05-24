package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

@Data
@AllArgsConstructor
@ToString
@Builder
public class StoreDto {
    private int storeId;            //store 고유 id
    private String storeName;       //store 이름
    private int payment;          //카드가맹점 or(and) 선한영향력가게
    //private String hygieneGrade;     //위생등급
    private int zipCode;            //우편번호
    private String roadAddr;
    private String lotAddr;
    private double wgs84Lat;
    private double wgs84Logt;
    //private double curDist;
    private String prodName;
    private String prodTarget;
    //private double totalRating;
}
