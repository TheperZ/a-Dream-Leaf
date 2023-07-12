package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.exception.StoreException;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import lombok.Builder;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.text.similarity.LevenshteinDistance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Repository
public class StoreRepositoryImpl implements StoreRepository{

    @Autowired
    private JdbcTemplate template;



    @Override
    @Transactional(rollbackFor = Exception.class)
    public Optional<StoreDto> save(StoreReq storeReq) {

        //음식점명, 위경도가 동일한 데이터가 있는지 확인(이 경우 임시로 같은 가게인 경우로 간주)
        String checkSql="select * from store where storeName=? and wgs84Lat=? and wgs84Logt=?";
        List<StoreDto> checkForDuplicate=template.query(checkSql, storeDtoRowMapper,
                storeReq.getStoreName(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt());
        if(checkForDuplicate.size()>0){
            log.info("no insert={}", storeReq.getStoreName());
            return Optional.empty();
        }


        String sql="insert into store(storeName, zipCode, roadAddr, lotAddr, wgs84Lat, wgs84Logt, payment, prodName, prodTarget) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        template.update(sql,
                storeReq.getStoreName(),
                storeReq.getZipCode(),
                storeReq.getRoadAddr(),
                storeReq.getLotAddr(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment(),
                storeReq.getProdName(),
                storeReq.getProdTarget());

        String resultSql="select * from store where storeName=? and zipCode=? and roadAddr=? and lotAddr=? and wgs84Lat=? and wgs84Logt=? and payment=? and prodName=? and prodTarget=?";
        return Optional.of(template.queryForObject(resultSql, storeDtoRowMapper, storeReq.getStoreName(),
                storeReq.getZipCode(),
                storeReq.getRoadAddr(),
                storeReq.getLotAddr(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment(),
                storeReq.getProdName(),
                storeReq.getProdTarget()));
    }
    @Override
    public Boolean hasAnotherType(StoreReq forCheck){
        String resultSql="select * from store where storeName=? and wgs84Lat=? and wgs84Logt=? and payment=?";
        List<StoreDto> temp=template.query(resultSql, storeDtoRowMapper,
                forCheck.getStoreName(),
                forCheck.getWgs84Lat(),
                forCheck.getWgs84Logt(),
                forCheck.getPayment());
        if(temp.size()>0){
            for(int i=0;i<temp.size();i++){
                log.info("i={} storeName={}, resName={}, lat={}, logt={}, payment={}",i, forCheck.getStoreName(),temp.get(i).getStoreName(), forCheck.getWgs84Lat(), forCheck.getWgs84Logt(), forCheck.getPayment());
            }
            return true;
        }else{
            return false;
        }
    }

    @Override
    public void updatePaymentTo2(StoreReq storeReq) {
        String sql="update store set payment=2 where storeName=? and wgs84Lat=? and wgs84Logt=? and payment=?";
        template.update(sql,
                storeReq.getStoreName(),
                storeReq.getWgs84Lat(),
                storeReq.getWgs84Logt(),
                storeReq.getPayment());

    }

    //사용자 위치 정보가 없을 때에 대한 처리
    @Override
    public Optional<DetailStoreDto> findById(int storeId){
        String sql="select store.*, 0.0 as distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store where storeId=?";
        try{
            DetailStoreDto result = template.queryForObject(sql, detailStoreDtoRowMapper, storeId);
            return Optional.of(result);
        }catch(EmptyResultDataAccessException e){
            throw new StoreException("가게를 찾을 수 없습니다.", 404);
        }
    }

    //사용자 위치 정보가 있을 때에 대한 처리
    @Override
    public Optional<DetailStoreDto> findById(int storeId, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store where storeId=?";
        try{
            DetailStoreDto result = template.queryForObject(sql, detailStoreDtoRowMapper,userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat(), storeId);
            return Optional.of(result);
        }catch(EmptyResultDataAccessException e){
            throw new StoreException("가게를 찾을 수 없습니다.", 404);
        }

    }

    //사용자 위치 정보가 없을 때에 대한 처리
    @Override
    public List<SimpleStoreDto> findByKeyword(String keyword){
        String sql="select *, 0.0 AS distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store where storeName like ? order by totalRating desc";
        List<SimpleStoreDto> result= template.query(sql, simpleStoreDtoRowMapper,"%"+keyword+"%");
        return result;
    }

    //사용자 위치 정보가 있을 때에 대한 처리
    @Override
    public List<SimpleStoreDto> findByKeyword(String keyword, UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store where storeName like ? order by distance";
        log.info("lat={}, logt={}", userCurReq.getCurLat(), userCurReq.getCurLogt());
        List<SimpleStoreDto> result= template.query(sql, simpleStoreDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat(),"%"+keyword+"%");
        return result;
    }

    @Override
    public List<SimpleStoreDto> findByCur(UserCurReq userCurReq) {
        String sql="select *, (6371*acos(cos(radians(?))*cos(radians(wgs84Lat))*cos(radians(wgs84Logt)" +
                "-radians(?))+sin(radians(?))*sin(radians(wgs84Lat))))" +
                "AS distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store having distance<2 order by distance";
        List<SimpleStoreDto> result=template.query(sql, simpleStoreDtoRowMapper, userCurReq.getCurLat(), userCurReq.getCurLogt(), userCurReq.getCurLat());
        return result;
    }

    //여기부터는 api 병합 관련 로직
    @Override
    public void checkAndMerge(){
        String sql="select a.storeName as aStore, b.storeName as bStore, a.wgs84Lat, a.wgs84Logt " +
                "from (select * from store where payment=0)a, (select * from store where payment=1)b " +
                "where a.wgs84Lat=b.wgs84Lat and a.wgs84Logt=b.wgs84Logt";
        List<CheckSameStore> result=template.query(sql, checkSameStoreRowMapper);
        for(CheckSameStore s:result){
            if(isSameStore(s)){
                log.info("mergeInfo: aStore={}, bStore={}", s.getAStore(), s.getBStore());
                mergeStore(s);
            }
        }
    }

    public double findSimilarity(String x, String y) {

        double maxLength = Double.max(x.length(), y.length());
        LevenshteinDistance ld=new LevenshteinDistance();
        if (maxLength > 0) {
            // 필요한 경우 선택적으로 대소문자를 무시합니다.
            return (maxLength - ld.apply(x, y)) / maxLength;
        }
        return 1.0;
    }


    public boolean isSameStore(CheckSameStore s){

        Map<String, String> degenerateCase=Map.ofEntries(
                Map.entry("꼬꼬불장작 동탄나루점", "참나무로구운누룽통닭꼬꼬불장작동탄나루점"),
                Map.entry("현일병의피자&치킨군단", "현일병의 피자군단"),
                Map.entry("벨라로사", "벨라로사/주식회사 우리요리"),
                Map.entry("아고라 샐러드", "아고라 샐러드(Agora salad)"),
                Map.entry("네네치킨앤봉구스밥버거", "네네치킨앤봉구스밥버거신천점(네네치킨&봉구스밥버거"),
                Map.entry("휴반어스", "휴반"),
                Map.entry("생고기제작소 양주옥정점", "생고기제작소"),
                Map.entry("햇살머믄꼬마김밥 향남점", "햇살머믄꼬마김밥"),
                Map.entry("돌체도노", "돌체도노(Dolce dono)")
        );


        if(findSimilarity(s.getAStore(), s.getBStore())>=0.7){
            return true;
        }
        else if(degenerateCase.get(s.getAStore())!=null && degenerateCase.get(s.getAStore()).equals(s.getBStore())){
            return true;
        }
        return false;
    }

    private void mergeStore(CheckSameStore s){
        String usql="update store set payment=2 where storeName=? and wgs84Lat=? and wgs84Logt=?";
        template.update(usql, s.getAStore(), s.getWgs84Lat(), s.getWgs84Logt());
        String dsql="delete from store where storeName=? and wgs84Lat=? and wgs84Logt=?";
        template.update(dsql, s.getBStore(), s.getWgs84Lat(), s.getWgs84Logt());
    }

    @Builder
    @Data
    public static class CheckSameStore{
        private String aStore;
        private String bStore;
        private double wgs84Lat;
        private double wgs84Logt;
    }



    //여기부터는 rowmapper

    private RowMapper<StoreDto> storeDtoRowMapper=(rs, rowNum) ->
            StoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .hygieneGrade("매우우수")
                    .zipCode(rs.getInt("zipCode"))
                    .roadAddr(rs.getString("roadAddr"))
                    .lotAddr(rs.getString("lotAddr"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .payment(rs.getInt("payment"))          //->storeType(rs.getInt("payment"))
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    .build();

    private RowMapper<SimpleStoreDto> simpleStoreDtoRowMapper=(rs, rowNum)->
            SimpleStoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .storeType(rs.getInt("payment"))
                    .curDist(rs.getDouble("distance"))      //현재 이 column이 없을 경우 0.0으로 처리
                    .totalRating(rs.getDouble("totalRating"))
                    .build();

    private RowMapper<DetailStoreDto> detailStoreDtoRowMapper=(rs, rowNum)->
            DetailStoreDto.builder()
                    .storeId(rs.getInt("storeId"))
                    .storeName(rs.getString("storeName"))
                    .hygieneGrade("매우우수")
                    .refinezipCd(rs.getInt("zipCode"))
                    .refineRoadnmAddr(rs.getString("roadAddr"))
                    .refineLotnoAddr(rs.getString("lotAddr"))
                    .refineWGS84Lat(rs.getDouble("wgs84Lat"))
                    .refineWGS84Logt(rs.getDouble("wgs84Logt"))
                    .curDist(rs.getDouble("distance"))
                    .storeType(rs.getInt("payment"))
                    .prodName(rs.getString("prodName"))
                    .prodTarget(rs.getString("prodTarget"))
                    .totalRating(rs.getDouble("totalRating"))
                    .build();
    private RowMapper<CheckSameStore> checkSameStoreRowMapper=(rs, rowNum)->
            CheckSameStore.builder()
                    .aStore(rs.getString("aStore"))
                    .bStore(rs.getString("bStore"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .build();



}
