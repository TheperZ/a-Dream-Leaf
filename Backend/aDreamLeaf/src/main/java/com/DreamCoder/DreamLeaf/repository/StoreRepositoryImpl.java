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
    @Transactional
    public StoreDto save(StoreReq storeReq) {
        String sql="insert into store(storeName, zipCode, roadAddr, lotAddr, wgs84Lat, wgs84Logt, payment, prodName, prodTarget) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        template.update(sql,
                storeReq.getStoreName(),
                storeReq.getZipCode(),
                storeReq.getRoadAddr(),
                storeReq.getLotAddr(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.isPayment(),
                storeReq.getProdName(),
                storeReq.getProdTarget());
        String resultSql="select * from store where roadAddr=?";       //수정 필요
        return template.queryForObject(resultSql, storeDtoRowMapper, storeReq.getRoadAddr());
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
                    .zipCode(rs.getInt("zipCode"))
                    .roadAddr(rs.getString("roadAddr"))
                    .lotAddr(rs.getString("lotAddr"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .payment(rs.getBoolean("payment"))
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    .build();



}
