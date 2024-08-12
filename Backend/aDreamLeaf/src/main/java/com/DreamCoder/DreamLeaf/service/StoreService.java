package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.domain.Store;
import com.DreamCoder.DreamLeaf.domain.StoreHygrade;
import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.exception.StoreException;
import com.DreamCoder.DreamLeaf.parser.ApiParser;
import com.DreamCoder.DreamLeaf.repository.ReviewRepositoryCustom;
import com.DreamCoder.DreamLeaf.repository.StoreHygradeRepository;
import com.DreamCoder.DreamLeaf.repository.StoreRepository;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreService {


    private final StoreRepository storeRepository;
    private final StoreHygradeRepository storeHygradeRepository;
    private final ReviewRepositoryCustom reviewRepository;
    private final ApiParser apiParser;


    public void save(StoreReq storeReq){

        //음식점명, 위경도가 동일한 데이터가 있는지 확인(이 경우 임시로 같은 가게인 경우로 간)
        if(storeRepository.existsByStoreNameAndWgs84LatAndWgs84Logt(storeReq.getStoreName(), storeReq.getWgs84Lat(), storeReq.getWgs84Logt())){
            log.info("no insert={}", storeReq.getStoreName());
            return;
        }

        Store store = Store.builder()
                .storeName(storeReq.getStoreName())
                .zipCode(storeReq.getZipCode())
                .roadAddr(storeReq.getRoadAddr())
                .lotAddr(storeReq.getLotAddr())
                .wgs84Lat(storeReq.getWgs84Lat())
                .wgs84Logt(storeReq.getWgs84Logt())
                .payment(storeReq.getPayment())
                .prodName(storeReq.getProdName())
                .prodTarget(storeReq.getProdTarget())
                .build();
       storeRepository.save(store);
    }

    public DetailStoreDto findById(Long storeId, UserCurReq userCurReq){

        Store store = storeRepository.findById(storeId).orElseThrow(
                () -> new StoreException("해당 가게정보가 존재하지 않습니다.", 404)
        );

        DetailStoreDto result = DetailStoreDto.builder()
                .storeId(store.getId())
                .storeName(store.getStoreName())
                .storeType(store.getPayment())
                .hygieneGrade(storeRepository.checkHygrade(store.getStoreName(), store.getWgs84Lat(), store.getWgs84Logt()))
                .refinezipCd(store.getZipCode())
                .refineRoadnmAddr(store.getRoadAddr())
                .refineLotnoAddr(store.getLotAddr())
                .refineWGS84Lat(store.getWgs84Lat())
                .refineWGS84Logt(store.getWgs84Logt())
                .prodName(store.getProdName())
                .prodTarget(store.getProdTarget())
                .totalRating(reviewRepository.getAvgScore(store.getId()))
                .build();

        if(userCurReq.getCurLat()!=null && userCurReq.getCurLogt()!=null &&
                (userCurReq.getCurLat() < -90 || userCurReq.getCurLat() > 90 || userCurReq.getCurLogt() < -180 || userCurReq.getCurLogt() > 180)){

            throw new StoreException("잘못된 위치정보입니다.", 400);

        }  else {

            result.setCurDist(calcDist(userCurReq.getCurLat(), userCurReq.getCurLogt(), result.getRefineWGS84Lat(), result.getRefineWGS84Logt()));
        }
        return result;
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
        List<Store> goodStores = apiParser.saveGoodStoreApi();

        for (Store goodStore : goodStores) {
            if (storeRepository.existsByStoreNameAndWgs84LatAndWgs84Logt(goodStore.getStoreName(), goodStore.getWgs84Lat(), goodStore.getWgs84Logt())) {
                storeRepository.save(goodStore);
            }

        }


        List<Store> gDreamCardStores = apiParser.saveGDreamCardApi();

        for (Store gDreamCardStore : gDreamCardStores) {
            if (storeRepository.existsByStoreNameAndWgs84LatAndWgs84Logt(gDreamCardStore.getStoreName(), gDreamCardStore.getWgs84Lat(), gDreamCardStore.getWgs84Logt())) {
                storeRepository.save(gDreamCardStore);
            }

        }
        storeRepository.checkAndMerge();
    }

    public void saveHyApi(){
        List<StoreHygrade> storeHygrades = apiParser.parseHygieneApi();

        for (StoreHygrade storeHygrade : storeHygrades) {
            storeHygradeRepository.save(storeHygrade);
        }
    }

    private double calcDist(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Radius of the earth

        Double latDistance = toRad(lat2 - lat1);
        Double lonDistance = toRad(lon2 - lon1);
        Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) +
                Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
                        Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

        return R * c;
    }

    private static Double toRad(Double value) {
        return value * Math.PI / 180;
    }


}
