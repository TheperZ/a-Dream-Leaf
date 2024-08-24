package com.DreamCoder.DreamLeaf.service;



import com.DreamCoder.DreamLeaf.repository.StoreHygradeRepository;
import com.DreamCoder.DreamLeaf.repository.StoreRepository;
import com.DreamCoder.DreamLeaf.req.StoreHygradeReq;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

@Slf4j
@Component
@RequiredArgsConstructor
public class ApiManager {


    private final StoreRepository storeRepository;
    private final StoreHygradeRepository storeHygradeRepository;

    private String makeUrl(String storeType, String key, String dataType, int pIndex, int pSize){
        StringBuffer urlBuffer=new StringBuffer();
        urlBuffer.append("https://openapi.gg.go.kr/");
        urlBuffer.append(storeType);
        urlBuffer.append("?KEY=");
        urlBuffer.append(key);
        urlBuffer.append("&Type=");
        urlBuffer.append(dataType);
        urlBuffer.append("&pIndex=");
        urlBuffer.append(pIndex);
        urlBuffer.append("&pSize=");
        urlBuffer.append(pSize);

        return urlBuffer.toString();
    }

    public void saveGDreamCardApi(){
        String result="";
        int pIndex=1;
        Long totalCnt;
        try{
            do{
            URL url=new URL(makeUrl("GDreamCard", "e67be2abc4464ffcb547fe1fecc6d138","json", pIndex, 1000));
            BufferedReader bf;
            bf=new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
            result=bf.readLine();


            JSONParser jsonParser=new JSONParser();
            JSONObject jsonObject=(JSONObject) jsonParser.parse(result);
            JSONArray gDreamCard=(JSONArray) jsonObject.get("GDreamCard");      //전체 json get(size=2(head, row))

            //casting head
            JSONObject head=(JSONObject)gDreamCard.get(0);
            JSONArray head2=(JSONArray)head.get("head");
            log.info("head={}", head2);
            totalCnt=(Long)((JSONObject)head2.get(0)).get("list_total_count");
            log.info("cnt={}", totalCnt);
            JSONObject apiResult=(JSONObject)((JSONObject)head2.get(1)).get("RESULT");
            String resultCode=(String)apiResult.get("CODE");
            log.info("resCode={}", resultCode);

            //casting body(row)
            JSONObject row=(JSONObject)gDreamCard.get(1);
            JSONArray infoArr=(JSONArray)row.get("row");



            for(int i=0;i<infoArr.size();i++) {
                JSONObject temp = (JSONObject) infoArr.get(i);

                //check zip, location if null

                double lat, logt;


                String lotno=temp.get("REFIND_LOTNO_ADDR")==null?"":(String) temp.get("REFINE_LOTNO_ADDR");

                int zipcd=temp.get("REFINE_ZIP_CD") == null?0:Integer.parseInt((String) temp.get("REFINE_ZIP_CD"));


                //위치기반 서비스이므로 위치 정보가 없는 가게는 추가하지 않기로 함
                if ((String) temp.get("REFINE_WGS84_LAT") == null || (String) temp.get("REFINE_WGS84_LOGT") == null) {
                    continue;
                }
                else{
                    lat = Double.parseDouble((String) temp.get("REFINE_WGS84_LAT"));
                    logt = Double.parseDouble((String) temp.get("REFINE_WGS84_LOGT"));
                }



                StoreReq checkForGoodStore = StoreReq.builder()
                        .storeName((String) temp.get("FACLT_NM"))
                        .zipCode(zipcd)
                        .roadAddr((String) temp.get("REFINE_ROADNM_ADDR"))
                        .lotAddr(lotno)
                        .wgs84Lat(lat)
                        .wgs84Logt(logt)
                        .payment(0)
                        .prodName("")
                        .prodTarget("")
                        .build();


                StoreReq checkForAllType = StoreReq.builder()
                        .storeName((String) temp.get("FACLT_NM"))
                        .zipCode(zipcd)
                        .roadAddr((String) temp.get("REFINE_ROADNM_ADDR"))
                        .lotAddr(lotno)
                        .wgs84Lat(lat)
                        .wgs84Logt(logt)
                        .payment(2)
                        .prodName("")
                        .prodTarget("")
                        .build();

                if(storeRepository.hasAnotherType(checkForGoodStore)){
                    storeRepository.updatePaymentTo2(checkForGoodStore);
                }
                else if(!storeRepository.hasAnotherType(checkForAllType)){
                        StoreReq infoObj = StoreReq.builder()
                                .storeName((String) temp.get("FACLT_NM"))
                                .zipCode(zipcd)
                                .roadAddr((String) temp.get("REFINE_ROADNM_ADDR"))
                                .lotAddr(lotno)
                                .wgs84Lat(lat)
                                .wgs84Logt(logt)
                                .payment(1)
                                .prodName("")
                                .prodTarget("")
                                .build();
                        storeRepository.save(infoObj);

                }

            }
            pIndex++;
            }while(pIndex<=(totalCnt/1000)+1);



        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void saveGoodStoreApi(){
        String result="";
        int pIndex=1;
        Long totalCnt;
        try{
            do{
                URL url=new URL(makeUrl("GGGOODINFLSTOREST", "fb1025fa7b1145fbbbc2a843c0d8c10e","json", pIndex, 1000));
                BufferedReader bf;
                bf=new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
                result=bf.readLine();


                JSONParser jsonParser=new JSONParser();
                JSONObject jsonObject=(JSONObject) jsonParser.parse(result);
                JSONArray goodStore=(JSONArray) jsonObject.get("GGGOODINFLSTOREST");      //전체 json get(size=2(head, row))

                //casting head
                JSONObject head=(JSONObject)goodStore.get(0);
                JSONArray head2=(JSONArray)head.get("head");
                log.info("head={}", head2);
                totalCnt=(Long)((JSONObject)head2.get(0)).get("list_total_count");
                log.info("cnt={}", totalCnt);
                JSONObject apiResult=(JSONObject)((JSONObject)head2.get(1)).get("RESULT");
                String resultCode=(String)apiResult.get("CODE");
                log.info("resCode={}", resultCode);

                //casting body(row)
                JSONObject row=(JSONObject)goodStore.get(1);
                JSONArray infoArr=(JSONArray)row.get("row");



                for(int i=0;i<infoArr.size();i++){
                    JSONObject temp=(JSONObject)infoArr.get(i);

                    //check zip, location if null

                    double lat, logt;


                    //음식점이 아닌 가게는 추가하지 않음
                    if(!((String)temp.get("INDUTYPE_NM")).equals("식음료")){
                        continue;
                    }

                    //정보가 없는 가게에 대한 String 처리
                    String roadno = temp.get("REFINE_ROADNM_ADDR") == null ? "" : (String) temp.get("REFINE_ROADNM_ADDR");

                    String lotno = temp.get("REFINE_LOTNO_ADDR") == null ? "" : (String) temp.get("REFINE_LOTNO_ADDR");

                    int zipcd = temp.get("REFINE_ZIPNO") == null ? 0 : Integer.parseInt((String) temp.get("REFINE_ZIPNO"));


                    //위치기반 서비스이므로 위치 정보가 없는 가게는 추가하지 않기로 함
                    if ((String) temp.get("REFINE_WGS84_LAT") == null || (String) temp.get("REFINE_WGS84_LOGT") == null) {
                        continue;
                    }
                    else{
                        lat = Double.parseDouble((String) temp.get("REFINE_WGS84_LAT"));
                        logt = Double.parseDouble((String) temp.get("REFINE_WGS84_LOGT"));
                    }

                    String prodName = temp.get("PROVSN_PRODLST_NM") == null ? "" : (String) temp.get("PROVSN_PRODLST_NM");

                    String prodTarget = temp.get("PROVSN_TRGT_NM1") == null ? "" : (String) temp.get("PROVSN_TRGT_NM1");

                    if(temp.get("PROVSN_TRGT_NM2")!=null){
                        prodTarget+=(String)temp.get("PROVSN_TRGT_NM2");
                    }


                    StoreReq checkFor1 = StoreReq.builder()
                            .storeName((String) temp.get("CMPNM_NM"))
                            .zipCode(zipcd)
                            .roadAddr(roadno)
                            .lotAddr(lotno)
                            .wgs84Lat(lat)
                            .wgs84Logt(logt)
                            .payment(1)
                            .prodName(prodName)
                            .prodTarget(prodTarget)
                            .build();

                    StoreReq checkFor2 = StoreReq.builder()
                            .storeName((String) temp.get("CMPNM_NM"))
                            .zipCode(zipcd)
                            .roadAddr(roadno)
                            .lotAddr(lotno)
                            .wgs84Lat(lat)
                            .wgs84Logt(logt)
                            .payment(2)
                            .prodName(prodName)
                            .prodTarget(prodTarget)
                            .build();



                    if(storeRepository.hasAnotherType(checkFor1)){
                        storeRepository.updatePaymentTo2(checkFor1);
                    }
                    else if(!storeRepository.hasAnotherType(checkFor2)){
                        StoreReq infoObj=new StoreReq((String)temp.get("CMPNM_NM"),
                                zipcd,
                                roadno,
                                lotno,
                                lat, logt,0, prodName, prodTarget);
                        storeRepository.save(infoObj);
                    }
                }
                pIndex++;
            }while(pIndex<=(totalCnt/1000)+1);
        }catch(Exception e){
            e.printStackTrace();
        }

    }

    public void saveHygieneApi(){
        String result="";
        int pIndex=1;
        Long totalCnt;
        try{
            do{
                URL url=new URL(makeUrl("RestrtSanittnGradStus", "1cbb5970a6a3461b8e4282e78a548c30","json", pIndex, 1000));
                BufferedReader bf;
                bf=new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
                result=bf.readLine();


                JSONParser jsonParser=new JSONParser();
                JSONObject jsonObject=(JSONObject) jsonParser.parse(result);
                JSONArray goodStore=(JSONArray) jsonObject.get("RestrtSanittnGradStus");      //전체 json get(size=2(head, row))

                //casting head
                JSONObject head=(JSONObject)goodStore.get(0);
                JSONArray head2=(JSONArray)head.get("head");
                log.info("head={}", head2);
                totalCnt=(Long)((JSONObject)head2.get(0)).get("list_total_count");
                log.info("cnt={}", totalCnt);
                JSONObject apiResult=(JSONObject)((JSONObject)head2.get(1)).get("RESULT");
                String resultCode=(String)apiResult.get("CODE");
                log.info("resCode={}", resultCode);

                //casting body(row)
                JSONObject row=(JSONObject)goodStore.get(1);
                JSONArray infoArr=(JSONArray)row.get("row");



                for(int i=0;i<infoArr.size();i++){
                    JSONObject temp=(JSONObject)infoArr.get(i);

                    //check location if null
                    double lat, logt;


                    //정보가 없는 가게에 대한 String 처리
                    String roadno = temp.get("REFINE_ROADNM_ADDR") == null ? "" : (String) temp.get("REFINE_ROADNM_ADDR");
                    String lotno = temp.get("REFINE_LOTNO_ADDR") == null ? "" : (String) temp.get("REFINE_LOTNO_ADDR");


                    //위치기반 서비스이므로 위치 정보가 없는 가게는 추가하지 않기로 함
                    if ((String) temp.get("REFINE_WGS84_LAT") == null || (String) temp.get("REFINE_WGS84_LOGT") == null) {
                        continue;
                    }
                    else{
                        lat = Double.parseDouble((String) temp.get("REFINE_WGS84_LAT"));
                        logt = Double.parseDouble((String) temp.get("REFINE_WGS84_LOGT"));
                    }


                    StoreHygradeReq infoObj = StoreHygradeReq.builder()
                            .storeName((String) temp.get("ENTRPS_NM"))
                            .grade((String) temp.get("APPONT_GRAD"))
                            .roadAddr(roadno)
                            .lotAddr(lotno)
                            .wgs84Lat(lat)
                            .wgs84Logt(logt)
                            .build();

                    storeHygradeRepository.save(infoObj);

                }
                pIndex++;
            }while(pIndex<=(totalCnt/1000)+1);
        }catch(Exception e){
            e.printStackTrace();
        }

    }







}
