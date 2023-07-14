package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.exception.StoreException;
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

    public Optional<DetailStoreDto> findById(int storeId, UserCurReq userCurReq){
        if(userCurReq.getCurLat()==null && userCurReq.getCurLogt()==null){
            return storeRepository.findById(storeId);
        }
        else if(userCurReq.getCurLat()<-90 || userCurReq.getCurLat()>90 || userCurReq.getCurLogt()<-180 || userCurReq.getCurLogt()>180){   //위치 정보가 wgs84 범위를 초과하였을 경우
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        return storeRepository.findById(storeId, userCurReq);
    }

    //사용자가 위치 정보 제공에 동의하였을 때외 하지 않았을 때에 대한 처리
    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq){
        if(userCurReq.getCurLat()==null && userCurReq.getCurLogt()==null){
            log.info("case1 lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
            return storeRepository.findByKeyword(keyword);
        }
        else if(userCurReq.getCurLat()<-90 || userCurReq.getCurLat()>90 || userCurReq.getCurLogt()<-180 || userCurReq.getCurLogt()>180){       //위치 정보가 wgs84 범위를 초과하였을 경우
            log.info("case2 lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        log.info("case3 lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
        return storeRepository.findByKeyword(keyword, userCurReq);
    }

    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq){           //클라이언트에게 위치 정보를 받아서 거리 계산
        if(userCurReq.getCurLat()<-90 || userCurReq.getCurLat()>90 || userCurReq.getCurLogt()<-180 || userCurReq.getCurLogt()>180){
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        return storeRepository.findByCur(userCurReq);
    }

    public void saveApi(){
//        apiManager.saveGoodStoreApi();
//        apiManager.saveGDreamCardApi();
        storeRepository.checkAndMerge();
//        apiManager.saveHygieneApi();
    }



}
