package com.DreamCoder.DreamLeaf.controller;


import com.DreamCoder.DreamLeaf.dto.StoreDto;
import com.DreamCoder.DreamLeaf.req.UserCurReq;
import com.DreamCoder.DreamLeaf.service.StoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@Slf4j
@RequestMapping("/restaurant")
@RequiredArgsConstructor
public class StoreController {

    @Autowired
    private final StoreService storeService;

    @GetMapping("/{storeId}")
    public StoreDto showStoreDetail(@PathVariable int storeId){
        return storeService.findById(storeId);
    }

    @GetMapping("/findByKeyword")
    public StoreDto findByKeyword(@RequestParam String q, @RequestBody UserCurReq userCurReq){       //거리 순으로 정렬
        return storeService.findByKeyword(q, userCurReq);
    }

    @GetMapping("/findByCur")
    public StoreDto findByCur(@RequestBody UserCurReq userCurReq){
        return storeService.findByCur(userCurReq);
    }

}
