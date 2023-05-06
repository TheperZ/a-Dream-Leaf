package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.UserCurReq;

public interface StoreRepository {
    public StoreDto save(StoreDto storeDto);
    public StoreDto findById(int id);
    public StoreDto findByKeyword(String keyword, UserCurReq userCurReq);       //사용자로부터의 거리 순으로 정렬
    public StoreDto findByCur(UserCurReq userCurReq);
}
