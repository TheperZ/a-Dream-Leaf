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

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void mergeStore(CheckSameStore s){
        String usql="update store set payment=2 where storeName=? and wgs84Lat=? and wgs84Logt=?";
        template.update(usql, s.getAStore(), s.getWgs84Lat(), s.getWgs84Logt());
        String dsql="delete from store where storeName=? and wgs84Lat=? and wgs84Logt=?";
        template.update(dsql, s.getBStore(), s.getWgs84Lat(), s.getWgs84Logt());
    }

    public String checkHygrade(String storeName, double wgs84Lat, double wgs84Logt){
        String checkSql="select a.storeName, a.grade, a.wgs84Lat, a.wgs84Logt from storeHygrade as a where wgs84Lat=? and wgs84Logt=?";
        List<CheckSameStoreHygrade> res=template.query(checkSql, checkSameStoreHygradeRowMapper, wgs84Lat, wgs84Logt);
        Map<String, String> degenerateCase2=Map.ofEntries(
                Map.entry("스트릿츄러스 롯데몰수원점","스트릿츄러스수원롯데몰"),
                Map.entry("땡초불닭발동대문엽기떡볶이","불닭발땡초동대문엽기떡볶이"),
                Map.entry("곡간 수제도시락","곡간"),
                Map.entry("빅빅버거 다산본점","빅빅버거"),
                Map.entry("파스타입니다-고양시청점","파스타입니다"),
                Map.entry("피자이탈리 구래점","피자이탈리(pizza italy) 구래점"),
                Map.entry("비에이치씨(BHC)화도창현점","BHC 화도창현점"),
                Map.entry("비에이치씨(bhc)다산중앙점","bhc 다산중앙점"),
                Map.entry("비에이치씨 덕풍점","bhc(비에이치씨) 덕풍점"),
                Map.entry("비에이치씨(BHC) 동탄방교점","BHC 동탄방교점"),
                Map.entry("(주)케이에프씨코리아 KFC일산후곡","케이에프씨(KFC) 일산후곡"),
                Map.entry("(주)현대그린푸드 h가든 테이크호텔","에이치가든테이크호텔점"),
                Map.entry("비에이치씨 김포양곡점","bhc김포양곡점"),
                Map.entry("비에이치씨(bhc)일산가좌점","bhc 일산가좌점"),
                Map.entry("비에치씨(BHC)용인송전점","(B.H.C)비에이치씨 용인송전점"),
                Map.entry("한국맥도날드 (유) 행신점","한국맥도날드행신점"),
                Map.entry("비알코리아(주)던킨도너츠 남양주호평","던킨도너츠 남양주호평점"),
                Map.entry("(주)피자알볼로 동탄","주식회사 피자알볼로동탄"),
                Map.entry("더제이케이키친박스","더제이케이키친박스(The JK KitchenBox)"),
                Map.entry("한국맥도날드 유한회사 행신점","한국맥도날드행신점"),
                Map.entry("(주)파리크라상 쉐이크쉑 AK분당플라자","쉐이크쉑 AK분당플라자점"),
                Map.entry("지에스25 용인한숲점","(주)지에스리테일GS수퍼용인한숲시티점"),
                Map.entry("비에이치씨(BHC)백석역점","BHC백석역점"),
                Map.entry("일미리금계찜닭","일미리금계찜닭배곧신도시점"),
                Map.entry("비비큐(BBQ) 매탄행복점","BBQ 매탄행복점"),
                Map.entry("비에이치씨(BHC) 부발점","BHC부발점"),
                Map.entry("본죽&까페비빔밥오산수청점","본죽오산수청점"),
                Map.entry("비에이치씨(BHC) 성대율전점","BHC성대율전점"),
                Map.entry("맥도날드부천원종DT점","한국맥도날드(유) 부천원종DT점"),
                Map.entry("비에이치씨치킨 부천괴안점","BHC치킨부천괴안점"),
                Map.entry("가유카페","가유카페 광교상현점"),
                Map.entry("비에이치씨(BHC)분당무지개점","BHC 분당무지개점"),
                Map.entry("비에이치씨 우만점","BHC 우만점"),
                Map.entry("교촌치킨 사동1호점","교촌치킨(사1동점)"),
                Map.entry("투썸플레이스 서판교점","투썸플레이스(Two Some Place) 서판교점"),
                Map.entry("비에이치씨(BHC)치킨 (석수중앙점)","비에이치씨치킨 석수중앙점"),
                Map.entry("버거킹 분당차병원점/(주)비케이알","버거킹 분당차병원점"),
                Map.entry("비에이치씨(BHC)곡반아이파크시티","비에이치시곡반아이파크시티(BHC곡반아이파크시티)"),
                Map.entry("파스쿠찌 죽전(서울방향)휴게소점","죽전(서울방향)휴게소 파스쿠찌"),
                Map.entry("비에이치씨(BHC)안중점","BHC평택안중점"),
                Map.entry("지에스(GS)25 진위힐스점","지에스25진위힐스점"),
                Map.entry("주식회사 카페티움","카페티움 주식회사"),
                Map.entry("VIPS중동소풍점/씨제이푸드빌(주)","씨제이푸드빌(주)빕스 중동소풍점"),
                Map.entry("지에스(GS)25 용인모현점","지에스25용인모현점"),
                Map.entry("비에이치씨(bhc) 치킨 서판교점","BHC 치킨 서판교점"),
                Map.entry("(비에이치씨)BHC호계융창점","BHC 호계융창점")
        );
        for(CheckSameStoreHygrade store:res){
            if(findSimilarity(storeName, store.getStoreName())>=0.7){
                Map<String, String> degenearateCase1=Map.ofEntries(
                        Map.entry("빽다방 별내파라곤스퀘어점", "더벤티 별내파라곤스퀘어점"),
                        Map.entry("아비꼬 판교파미어스몰점", "이디야 판교파미어스몰점")
                );
                if(degenearateCase1.get(storeName)!=null && degenearateCase1.get(storeName).equals(store.getStoreName())){      //높은 편집거리의 다른 가게 걸러내기
                    return "";
                }
                return store.getGrade();
            }
            else if (degenerateCase2.get(storeName)!=null && degenerateCase2.get(storeName).equals(store.getStoreName())){      //낮은 편집거리의 같은 가게 위생등급 적용하기
                return store.getGrade();
            }

        }

        return "";

    }

    @Builder
    @Data
    static class CheckSameStore{
        private String aStore;
        private String bStore;
        private double wgs84Lat;
        private double wgs84Logt;
    }

    @Builder
    @Data
    static class CheckSameStoreHygrade{
        private String storeName;
        private String grade;
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
                    .hygieneGrade(checkHygrade(rs.getString("storeName"), rs.getDouble("wgs84Lat"), rs.getDouble("wgs84Logt")))
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

    private RowMapper<CheckSameStoreHygrade> checkSameStoreHygradeRowMapper=(rs, rowNum)->
            CheckSameStoreHygrade.builder()
                    .storeName(rs.getString("storeName"))
                    .grade(rs.getString("grade"))
                    .wgs84Lat(rs.getDouble("wgs84Lat"))
                    .wgs84Logt(rs.getDouble("wgs84Logt"))
                    .build();



}
