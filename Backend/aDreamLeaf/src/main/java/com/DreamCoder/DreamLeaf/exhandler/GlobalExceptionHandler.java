package com.DreamCoder.DreamLeaf.exhandler;

import com.DreamCoder.DreamLeaf.exception.AccountException;
import com.DreamCoder.DreamLeaf.exception.AlarmException;
import com.google.firebase.auth.AuthErrorCode;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.MessagingErrorCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = {AccountException.class})
    protected ResponseEntity handleAccountException(AccountException e){
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage",e.getMessage());
        return ResponseEntity.status(e.getCode()).body(result);
    }

    @ExceptionHandler(value = {AlarmException.class})
    protected ResponseEntity handleAccountException(AlarmException e){
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage",e.getMessage());
        return ResponseEntity.status(e.getCode()).body(result);
    }

    @ExceptionHandler(value = {FirebaseAuthException.class})
    protected ResponseEntity handleFirebaseAuthException(FirebaseAuthException e){
        AuthErrorCode authErrorCode = e.getAuthErrorCode();
        Map<String,String> result = new HashMap<>();
        result.put("message","파이어베이스 인증에 실패하였습니다.");
        result.put("authErrorCode", authErrorCode.toString());
        return ResponseEntity.status(500).body(result);
    }

    @ExceptionHandler(value = {FirebaseMessagingException.class})
    protected ResponseEntity handleFirebaseMessagingException(FirebaseMessagingException e){
        MessagingErrorCode messagingErrorCode = e.getMessagingErrorCode();
        Map<String,String> result = new HashMap<>();
        result.put("message","파이어베이스 메세지 전송에 실패하였습니다.");
        result.put("authErrorCode", messagingErrorCode.toString());
        return ResponseEntity.status(500).body(result);
    }
}
