package com.DreamCoder.DreamLeaf.controller;


import com.DreamCoder.DreamLeaf.dto.DetailStoreDto;
import com.DreamCoder.DreamLeaf.dto.SimpleStoreDto;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import com.DreamCoder.DreamLeaf.service.ApiManager;
import com.DreamCoder.DreamLeaf.service.StoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@Slf4j
@RequestMapping("/restaurant")
@RequiredArgsConstructor
public class StoreController {


    private final StoreService storeService;


    @PostMapping("/api")
    public ResponseEntity saveApi(){

        storeService.saveApi();
        return ResponseEntity.status(HttpStatus.CREATED).body("");

    }

    @PostMapping("/api/hygiene")
    public ResponseEntity saveHygiene(){
        storeService.saveHyApi();
        return ResponseEntity.status(201).body("위생정보 저장이 완료 되었습니다.");
    }

    @PostMapping("/{storeId}")
    public Optional<DetailStoreDto> showStoreDetail(@PathVariable int storeId, @RequestBody(required = false) UserCurReq userCurReq){
        return storeService.findById(storeId, userCurReq);
    }

    @PostMapping("/findByKeyword")
    public List<SimpleStoreDto> findByKeyword(@RequestParam String keyword, @RequestBody(required = false) UserCurReq userCurReq){       //위치 정보가 있을 경우 거리 순으로 정렬, 없을 경우 별점 순으로 정렬
        return storeService.findByKeyword(keyword, userCurReq);
    }

    @PostMapping("/findByCur")
    public List<SimpleStoreDto> findByCur(@RequestBody UserCurReq userCurReq){
        return storeService.findByCur(userCurReq);
    }



}


