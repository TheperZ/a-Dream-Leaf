package com.DreamCoder.DreamLeaf.controller;


import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.StoreReq;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import com.DreamCoder.DreamLeaf.service.StoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.NumberUtils;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.List;
import java.util.Optional;

@RestController
@Slf4j
@RequestMapping("/restaurant")
@RequiredArgsConstructor
public class StoreController {

    @Autowired
    private final StoreService storeService;

//    @PostMapping("/save")    //for test
//    public ResponseEntity save(@RequestBody StoreReq storeReq){
//        return ResponseEntity.status(HttpStatus.CREATED).body(storeService.create(storeReq));
//    }

    @PostMapping("/api")
    public ResponseEntity saveGDreamCardApi(){
        String result="";
        try{
            URL url=new URL("https://openapi.gg.go.kr/GDreamCard?KEY=e67be2abc4464ffcb547fe1fecc6d138&Type=json");
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
            Long totalCnt=(Long)((JSONObject)head2.get(0)).get("list_total_count");
            log.info("cnt={}", totalCnt);
            JSONObject apiResult=(JSONObject)((JSONObject)head2.get(1)).get("RESULT");
            String resultCode=(String)apiResult.get("CODE");
            log.info("resCode={}", resultCode);

            //casting body(row)
            JSONObject row=(JSONObject)gDreamCard.get(1);
            JSONArray infoArr=(JSONArray)row.get("row");



            for(int i=0;i<infoArr.size();i++){
                JSONObject temp=(JSONObject)infoArr.get(i);

                //check zip, location if null
                int zipcd;
                double lat, logt;
                String lotno;

                if((String)temp.get("REFINE_LOTNO_ADDR")==null){
                    lotno="";
                }
                else{
                    lotno=(String)temp.get("REFINE_LOTNO_ADDR");
                }
                if((String)temp.get("REFINE_ZIP_CD")==null){
                    zipcd=0;
                }
                else{
                    zipcd=Integer.parseInt((String)temp.get("REFINE_ZIP_CD"));
                }
                if((String)temp.get("REFINE_WGS84_LAT")==null){
                    lat=0;
                }
                else{
                    lat=Double.parseDouble((String)temp.get("REFINE_WGS84_LAT"));
                }
                if((String)temp.get("REFINE_WGS84_LOGT")==null){
                    logt=0;
                }
                else{
                    logt=Double.parseDouble((String)temp.get("REFINE_WGS84_LOGT"));
                }


                StoreReq infoObj=new StoreReq((String)temp.get("FACLT_NM"),
                        zipcd,
                        (String)temp.get("REFINE_ROADNM_ADDR"),
                        lotno,
                        lat, logt,true, null, null);
                storeService.save(infoObj);
            }



        }catch(Exception e){
            e.printStackTrace();
        }

        return ResponseEntity.status(HttpStatus.CREATED).body("");

    }

    @GetMapping("/{storeId}")
    public Optional<StoreDto> showStoreDetail(@PathVariable int storeId){
        return storeService.findById(storeId);
    }

    @PostMapping("/findByKeyword")
    public List<StoreDto> findByKeyword(@RequestParam String keyword, @RequestBody UserCurReq userCurReq){       //거리 순으로 정렬
        return storeService.findByKeyword(keyword, userCurReq);
    }

    @PostMapping("/findByCur")
    public List<StoreDto> findByCur(@RequestBody UserCurReq userCurReq){
        return storeService.findByCur(userCurReq);
    }

}


