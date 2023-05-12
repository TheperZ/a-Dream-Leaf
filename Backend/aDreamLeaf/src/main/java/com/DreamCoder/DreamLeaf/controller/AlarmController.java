package com.DreamCoder.DreamLeaf.controller;

import com.DreamCoder.DreamLeaf.Util.AuthUtil;
import com.DreamCoder.DreamLeaf.dto.AddAlarmDto;
import com.DreamCoder.DreamLeaf.req.AddAlarmReq;
import com.DreamCoder.DreamLeaf.service.AlarmService;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.messaging.FirebaseMessagingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AlarmController {

    @Autowired
    private final AlarmService alarmService;
    private final AuthUtil authUtil;

    @PostMapping("/alarm/add")
    public ResponseEntity setAlarm(@RequestBody AddAlarmReq addAlarmReq) throws FirebaseAuthException, FirebaseMessagingException {
        int id = authUtil.findUserId(addAlarmReq.getFirebaseToken());
        AddAlarmDto addAlarmDto = new AddAlarmDto(addAlarmReq.getFCMToken(), id);
        String result = alarmService.add(addAlarmDto);
        return ResponseEntity.status(201).body(result);
    }

    @PostMapping("/alarm/delete")
    public ResponseEntity deleteAlarm(@RequestBody Map<String,String> req) throws FirebaseAuthException, FirebaseMessagingException{
        int id = authUtil.findUserId(req.get("firebaseToken"));
        String result = alarmService.delete(id);
        return ResponseEntity.ok().body(result);
    }

    @GetMapping("/alarm")
    public ResponseEntity doAlarm(){
        alarmService.sending();
        return ResponseEntity.ok().body("");
    }

}
