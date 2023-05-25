package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
@AllArgsConstructor
@ToString
@Builder
public class StoreReq {
    private String storeName;       //store 이름
    private int zipCode;            //우편번호
    private String roadAddr;        //도로명주소
    private String lotAddr;         //지번주소
    private double wgs84Lat;        //위도
    private double wgs84Logt;       //경도
    private int payment;        //아동급식카드 지원여부
    private String prodName;        //제공품목
    private String prodTarget;      //제공대상
}
