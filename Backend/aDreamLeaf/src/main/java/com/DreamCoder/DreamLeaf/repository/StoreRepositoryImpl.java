package com.DreamCoder.DreamLeaf.repository;

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

    @Override
    public Optional<StoreDto> findById(int storeId) {
        String sql="select * from store where storeId=?";
        try{
            StoreDto storeDto = template.queryForObject(sql, storeDtoRowMapper, storeId);
            return Optional.of(storeDto);
        }catch(EmptyResultDataAccessException e){
            return Optional.empty();
        }

    }

    @Override
    public List<StoreDto> findByKeyword(String keyword, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store where storeName like ? order by distance";
        log.info("lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
        return template.query(sql, storeDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat(),"%"+keyword+"%");
    }

    @Override
    public List<StoreDto> findByCur(UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store having distance<2 order by distance";
        return template.query(sql, storeDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat());
    }



    private RowMapper<StoreDto> storeDtoRowMapper=(rs, rowNum) ->
            StoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    //.hygieneGrade("매우우수(임시)")
                    .zipCode(rs.getInt("zipCode"))
                    .roadAddr(rs.getString("roadAddr"))
                    .lotAddr(rs.getString("lotAddr"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    //.curDist(0.0)
                    .payment(rs.getInt("payment"))
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    //.totalRating(5.0)
                    .build();



}
