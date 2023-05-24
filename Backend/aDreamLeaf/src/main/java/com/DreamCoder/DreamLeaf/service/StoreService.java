package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.repository.StoreRepository;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreService {

    @Autowired
    private final StoreRepository storeRepository;
    private final ApiManager apiManager;


    public Optional<StoreDto> save(StoreReq storeReq){
        return storeRepository.save(storeReq);
    }

    public Optional<DetailStoreDto> findById(int storeId){
        return storeRepository.findById(storeId);
    }

    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq){
        return storeRepository.findByKeyword(keyword, userCurReq);
    }

    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq){           //클라이언트에게 위치 정보를 받아서 거리 계산
        return storeRepository.findByCur(userCurReq);
    }

    public void saveApi(){
        apiManager.saveGoodStoreApi();
        apiManager.saveGDreamCardApi();
    }



}
