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
public class StoreHygrade{

    @Id
    @GeneratedValue
    private Long id;
    private String storeName;       //store 이름
    private String grade;
    private String roadAddr;        //도로명주소
    private String lotAddr;         //지번주소
    private double wgs84Lat;        //위도
    private double wgs84Logt;       //경도
}