package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Repository
public class StoreRepositoryImpl implements StoreRepository{

    @Autowired
    private JdbcTemplate template;



    @Override
    @Transactional(rollbackFor = Exception.class)
    public Optional<StoreDto> save(StoreReq storeReq) {

        //음식점명, 위경도가 동일한 데이터가 있는지 확인
        String checkSql="select * from store where storeName=? and wgs84Lat=? and wgs84Logt=?";
        List<StoreDto> checkForDuplicate=template.query(checkSql, storeDtoRowMapper,
                storeReq.getStoreName(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt());
        if(checkForDuplicate.size()>0){
            log.info("no insert={}", storeReq.getStoreName());
            return Optional.empty();
        }


        String sql="insert into store(storeName, zipCode, roadAddr, lotAddr, wgs84Lat, wgs84Logt, payment, prodName, prodTarget) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        template.update(sql,
                storeReq.getStoreName(),
                storeReq.getZipCode(),
                storeReq.getRoadAddr(),
                storeReq.getLotAddr(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment(),
                storeReq.getProdName(),
                storeReq.getProdTarget());

        String resultSql="select * from store where storeName=? and zipCode=? and roadAddr=? and lotAddr=? and wgs84Lat=? and wgs84Logt=? and payment=? and prodName=? and prodTarget=?";
        return Optional.of(template.queryForObject(resultSql, storeDtoRowMapper, storeReq.getStoreName(),
                storeReq.getZipCode(),
                storeReq.getRoadAddr(),
                storeReq.getLotAddr(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment(),
                storeReq.getProdName(),
                storeReq.getProdTarget()));
    }
    @Override
    public Boolean hasAnotherType(StoreReq forCheck){
        String resultSql="select * from store where storeName=? and wgs84Lat=? and wgs84Logt=? and payment=?";
        List<StoreDto> temp=template.query(resultSql, storeDtoRowMapper,
                forCheck.getStoreName(),
                forCheck.getWgs84Lat(),
                forCheck.getWgs84Logt(),
                forCheck.getPayment());
        if(temp.size()>0){
            for(int i=0;i<temp.size();i++){
                log.info("i={} storeName={}, resName={}, lat={}, logt={}, payment={}",i, forCheck.getStoreName(),temp.get(i).getStoreName(), forCheck.getWgs84Lat(), forCheck.getWgs84Logt(), forCheck.getPayment());
            }
            return true;
        }else{
            return false;
        }
    }

    @Override
    public void updatePaymentTo2(StoreReq storeReq) {
        String sql="update store set payment=2 where storeName=? and wgs84Lat=? and wgs84Logt=? and payment=?";
        template.update(sql,
                storeReq.getStoreName(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment());

    }

    //사용자 위치 정보가 없을 때에 대한 처리
    @Override
    public Optional<DetailStoreDto> findById(int storeId){
        String sql="select *, 0.0 as distance from store where storeId=?";
        try{
            DetailStoreDto result = template.queryForObject(sql, detailStoreDtoRowMapper, storeId);
            return Optional.of(result);
        }catch(EmptyResultDataAccessException e){
            return Optional.empty();
        }
    }

    //사용자 위치 정보가 있을 때에 대한 처리
    @Override
    public Optional<DetailStoreDto> findById(int storeId, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store where storeId=?";
        try{
            DetailStoreDto result = template.queryForObject(sql, detailStoreDtoRowMapper,userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat(), storeId);
            return Optional.of(result);
        }catch(EmptyResultDataAccessException e){
            return Optional.empty();
        }

    }

    //사용자 위치 정보가 없을 때에 대한 처리(별점 순 정렬 추가 필요)
    @Override
    public List<SimpleStoreDto> findByKeyword(String keyword){
        String sql="select *, 0.0 AS distance from store where storeName like ? order by distance";
        return template.query(sql, simpleStoreDtoRowMapper,"%"+keyword+"%");
    }

    //사용자 위치 정보가 있을 때에 대한 처리
    @Override
    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store where storeName like ? order by distance";
        log.info("lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
        return template.query(sql, simpleStoreDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat(),"%"+keyword+"%");
    }

    @Override
    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store having distance<2 order by distance";
        return template.query(sql, simpleStoreDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat());
    }


//    //정말로 필요한 함수일까?
//    private double calcDistance(double lat1, double logt1, double lat2, double logt2){
//        double dLat = Math.toRadians(lat2 - lat1);
//        double dLon = Math.toRadians(logt2 - logt1);
//
//        double a = Math.sin(dLat/2)* Math.sin(dLat/2)+ Math.cos(Math.toRadians(lat1))* Math.cos(Math.toRadians(lat2))* Math.sin(dLon/2)* Math.sin(dLon/2);
//        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
//        double d = 6371 * c * 1000;    // Distance in m
//        return d;
//    }



    private RowMapper<StoreDto> storeDtoRowMapper=(rs, rowNum) ->
            StoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .hygieneGrade("매우우수")
                    .zipCode(rs.getInt("zipCode"))
                    .roadAddr(rs.getString("roadAddr"))
                    .lotAddr(rs.getString("lotAddr"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .payment(rs.getInt("payment"))          //->storeType(rs.getInt("payment")
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    .build();

    private RowMapper<SimpleStoreDto> simpleStoreDtoRowMapper=(rs, rowNum)->
            SimpleStoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .storeType(rs.getInt("payment"))
                    .curDist(rs.getDouble("distance"))      //현재 이 column이 없을 경우 0.0으로 처리
                    .totalRating(5.0)
                    .build();

    private RowMapper<DetailStoreDto> detailStoreDtoRowMapper=(rs, rowNum)->
            DetailStoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .hygieneGrade("매우우수")
                    .refinezipCd(rs.getInt("zipCode"))
                    .refineRoadnmAddr(rs.getString("roadAddr"))
                    .refineLotnoAddr(rs.getString("lotAddr"))
                    .refineWGS84Lat(rs.getDouble("wgs84Lat"))
                    .refineWGS84Logt(rs.getDouble("wgs84Logt"))
                    .curDist(rs.getDouble("distance"))
                    .storeType(rs.getInt("payment"))
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    .totalRating(5.0)
                    .build();



}
