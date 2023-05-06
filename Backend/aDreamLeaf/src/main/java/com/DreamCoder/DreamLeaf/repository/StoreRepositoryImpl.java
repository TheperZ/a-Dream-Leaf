package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class StoreRepositoryImpl implements StoreRepository{

    @Autowired
    private JdbcTemplate template;

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


    @Override
    public StoreDto save(StoreDto storeDto) {
        String sql="insert into store(storeName, zipCode, roadAddr, lotAddr, wgs84Lat, wgs84Logt, payment, prodName, prodTarget) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        template.update(sql,
                storeDto.getStoreName(),
                storeDto.getZipCode(),
                storeDto.getRoadAddr(),
                storeDto.getLotAddr(),
                storeDto.getWgs84Lat(),
                storeDto.getWgs84Logt(),
                storeDto.isPayment(),
                storeDto.getProdName(),
                storeDto.getProdTarget());
        return storeDto;
    }

    @Override
    public StoreDto findById(int storeId) {
        String sql="select * from store where storeId=?";
        return template.queryForObject(sql,storeDtoRowMapper, storeId);
    }

    @Override
    public StoreDto findByKeyword(String keyword, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store where storeName like ? having distance<2 order by distance";
        return template.queryForObject(sql, storeDtoRowMapper, userCurReq.getUserLat(), userCurReq.getUserLogt(), userCurReq.getUserLat(),"%"+keyword+"%");
    }

    @Override
    public StoreDto findByCur(UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance from store where storeName like ? having distance<2 order by distance";
        return template.queryForObject(sql, storeDtoRowMapper, userCurReq.getUserLat(), userCurReq.getUserLogt(), userCurReq.getUserLat());
    }



}
