package com.DreamCoder.DreamLeaf.req;


import lombok.*;

@Getter
@AllArgsConstructor
@ToString
@Builder
public class StoreHygradeReq {
    private String storeName;
    private String grade;
    private String roadAddr;
    private String lotAddr;
    private double wgs84Lat;        //위도
    private double wgs84Logt;       //경도
}
