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
        if(userCurReq==null){
            return storeRepository.findById(storeId);
        }
        else if(userCurReq.getCurLat()==0 || userCurReq.getCurLogt()==0){   //위치 정보 중 하나가 잘 못 들어왔을 경우 0.0으로 들어옴, 이에 대한 처리
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        return storeRepository.findById(storeId, userCurReq);
    }

    //사용자가 위치 정보 제공에 동의하였을 때외 하지 않았을 때에 대한 처리
    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq){
        if(userCurReq==null){
            return storeRepository.findByKeyword(keyword);
        }
        else if(userCurReq.getCurLat()==0 || userCurReq.getCurLogt()==0){
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        return storeRepository.findByKeyword(keyword, userCurReq);
    }

    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq){           //클라이언트에게 위치 정보를 받아서 거리 계산
        if(userCurReq.getCurLat()==0 || userCurReq.getCurLogt()==0){
            throw new StoreException("잘못된 위치정보입니다.", 400);
        }
        return storeRepository.findByCur(userCurReq);
    }

    public void saveApi(){
        apiManager.saveGoodStoreApi();
        apiManager.saveGDreamCardApi();
        apiManager.saveHygieneApi();
    }



}
