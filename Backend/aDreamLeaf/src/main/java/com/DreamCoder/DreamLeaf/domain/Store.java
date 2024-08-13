package com.DreamCoder.DreamLeaf.domain;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@ToString
@Builder
public class Store{

    @Id
    @GeneratedValue
    private Long storeId;

    private String storeName;       //store 이름
    private int zipCode;            //우편번호
    private String roadAddr;        //도로명주소
    private String lotAddr;         //지번주소
    private double wgs84Lat;        //위도
    private double wgs84Logt;       //경도
    private int payment;        //아동급식카드 지원여부
    @Builder.Default
    private String prodName = "";        //제공품목
    @Builder.Default
    private String prodTarget = "";      //제공대상
}