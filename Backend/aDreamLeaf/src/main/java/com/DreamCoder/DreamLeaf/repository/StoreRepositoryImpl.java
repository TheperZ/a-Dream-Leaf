package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import org.springframework.jdbc.core.JdbcTemplate;

public class StoreRepositoryImpl implements StoreRepository{

    private JdbcTemplate jdbcTemplate;


    @Override
    public StoreDto save(StoreDto storeDto) {
        return null;
    }

    @Override
    public StoreDto findByKeyword(String keyword) {
        return null;
    }

    @Override
    public StoreDto findByCur(Integer curLat, Integer curLogt) {
        return null;
    }

}
