package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreDto;

public interface StoreRepository {
    public StoreDto save(StoreDto storeDto);
    public StoreDto findByKeyword(String keyword);
    public StoreDto findByCur(Integer curLat, Integer cudLogt);
}
