package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
@AllArgsConstructor
@ToString
@Builder
public class DetailStoreDto {
    private Long storeId;            //store 고유 id
    private String storeName;       //store 이름
    private int storeType;          //카드가맹점 or(and) 선한영향력가게
    private String hygieneGrade;     //위생등급
    private int refinezipCd;            //우편번호
    private String refineRoadnmAddr;        //도로명주소
    private String refineLotnoAddr;         //지번주소
    private double refineWGS84Lat;        //위도
    private double refineWGS84Logt;       //경도
    @Builder.Default
    private double curDist = 0;         //현재 위치로부터의 거리
    private String prodName;        //제공품목
    private String prodTarget;      //제공대상
    private double totalRating;     //평균 리뷰점수
}
