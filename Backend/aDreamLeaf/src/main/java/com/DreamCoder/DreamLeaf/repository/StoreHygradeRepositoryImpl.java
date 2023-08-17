package com.DreamCoder.DreamLeaf.repository;


import com.DreamCoder.DreamLeaf.dto.StoreHygradeDto;
import com.DreamCoder.DreamLeaf.req.StoreHygradeReq;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class StoreHygradeRepositoryImpl implements StoreHygradeRepository{

    @Autowired
    private JdbcTemplate template;


    @Override
    public Optional<StoreHygradeDto> save(StoreHygradeReq storeHygradeReq) {
        String checkSql="select * from storehygrade where storeName=? and wgs84Lat=? and wgs84Logt=?";
        List<StoreHygradeDto> checkForDuplicate=template.query(checkSql, storeHygradeDtoRowMapper, storeHygradeReq.getStoreName(), storeHygradeReq.getWgs84Lat(), storeHygradeReq.getWgs84Logt());
        if(checkForDuplicate.size()>0){
            return Optional.empty();
        }
        String insertSql="insert into storehygrade(storeName, grade, roadAddr, lotAddr, wgs84Lat, wgs84Logt) values(?, ?, ?, ?, ?, ?)";
        template.update(insertSql, storeHygradeReq.getStoreName(), storeHygradeReq.getGrade(),storeHygradeReq.getRoadAddr(),storeHygradeReq.getLotAddr(), storeHygradeReq.getWgs84Lat(), storeHygradeReq.getWgs84Logt());
        String resultSql="select * from storehygrade where storeName=? and grade=? and roadAddr=? and lotAddr=? and wgs84Lat=? and wgs84Logt=?";
        return Optional.of(template.queryForObject(resultSql, storeHygradeDtoRowMapper, storeHygradeReq.getStoreName(), storeHygradeReq.getGrade(),storeHygradeReq.getRoadAddr(),storeHygradeReq.getLotAddr(), storeHygradeReq.getWgs84Lat(), storeHygradeReq.getWgs84Logt()));
    }


    private RowMapper<StoreHygradeDto> storeHygradeDtoRowMapper=(rs, rowNum) ->
            StoreHygradeDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .grade(rs.getString("grade"))
                    .roadAddr(rs.getString("roadAddr"))
                    .lotAddr(rs.getString("lotAddr"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .build();
}
