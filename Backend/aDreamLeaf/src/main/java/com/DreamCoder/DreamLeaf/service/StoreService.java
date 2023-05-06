package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.repository.StoreRepository;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreService {

    @Autowired
    private final StoreRepository storeRepository;

    public StoreDto create(StoreDto storeDto){
        return storeRepository.save(storeDto);
    }

    public StoreDto findById(int storeId){
        return storeRepository.findById(storeId);
    }

    public StoreDto findByKeyword(String keyword, UserCurReq userCurReq){
        return storeRepository.findByKeyword(keyword, userCurReq);
    }

    public StoreDto findByCur(UserCurReq userCurReq){           //클라이언트에게 위치 정보를 받아서 거리 계산?
        return storeRepository.findByCur(userCurReq);
    }

}
