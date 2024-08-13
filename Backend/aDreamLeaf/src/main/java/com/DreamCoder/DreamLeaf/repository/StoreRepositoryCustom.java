package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface StoreRepositoryCustom {



    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq);

    Boolean hasAnotherType(StoreReq forCheck);

    public void updatePaymentTo2(StoreReq storeReq);

    public void checkAndMerge();

    @Transactional(rollbackFor = Exception.class)
    void mergeStore(StoreRepositoryImpl.CheckSameStore s);

    String checkHygrade(String storeName, double wgs84Lat, double wgs84Logt);
}
