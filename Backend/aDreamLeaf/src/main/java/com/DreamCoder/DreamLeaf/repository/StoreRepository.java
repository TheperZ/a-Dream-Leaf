package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;

import java.util.List;
import java.util.Optional;

public interface StoreRepository {
    public Optional<StoreDto> save(StoreReq storeReq);
    public Optional<StoreDto> findById(int id);
    public List<StoreDto> findByKeyword(String keyword, UserCurReq userCurReq);       //사용자로부터의 거리 순으로 정렬
    public List<StoreDto> findByCur(UserCurReq userCurReq);

    Boolean hasAnotherType(StoreReq forCheck);

    public void updatePaymentTo2(StoreReq storeReq);
}
