package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface StoreRepositoryCustom {

    
    public List<SimpleStoreDto> findByKeyword(String keyword);          //사용자가 위치 정보 제공을 거부하였을 경우 별점 순으로 정렬
    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq);       //사용자로부터의 거리 순으로 정렬
    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq);

    Boolean hasAnotherType(StoreReq forCheck);

    public void updatePaymentTo2(StoreReq storeReq);

    public void checkAndMerge();

    @Transactional(rollbackFor = Exception.class)
    void mergeStore(StoreRepositoryImpl.CheckSameStore s);

    String checkHygrade(String storeName, double wgs84Lat, double wgs84Logt);
}
