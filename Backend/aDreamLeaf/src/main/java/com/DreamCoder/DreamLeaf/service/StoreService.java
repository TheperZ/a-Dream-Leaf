package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.repository.StoreRepository;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreService {

    private final StoreRepository storeRepository;

    public StoreDto create(StoreDto storeDto){
        return storeRepository.save(storeDto);
    }

    public StoreDto findByKeyword(String keyword){
        return storeRepository.findByKeyword(keyword);
    }

    public StoreDto findByCur(UserCurReq userCurReq){
        return storeRepository.findByCur(userCurReq.getUserLat(), userCurReq.getUserLogt());
    }

}
