package com.DreamCoder.DreamLeaf.exhandler;

import com.DreamCoder.DreamLeaf.exception.AccountException;
import com.DreamCoder.DreamLeaf.exception.AlarmException;
import com.DreamCoder.DreamLeaf.exception.ReviewException;
import com.DreamCoder.DreamLeaf.exception.SignUpException;
import com.DreamCoder.DreamLeaf.exception.StoreException;
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

    @ExceptionHandler(value = {ReviewException.class})
    protected ResponseEntity handleReviewException(ReviewException e){
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage",e.getMessage());
        return ResponseEntity.status(e.getCode()).body(result);
    }

    @ExceptionHandler(value = {StoreException.class})
    protected ResponseEntity handleStoreException(StoreException e){
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage",e.getMessage());
        return ResponseEntity.status(e.getCode()).body(result);
    }

    @ExceptionHandler(value = {SignUpException.class})
    protected ResponseEntity handleSignUpException(SignUpException e){
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage",e.getMessage());
        return ResponseEntity.status(e.getCode()).body(result);
    }

    @ExceptionHandler(value = {FirebaseAuthException.class})
    protected ResponseEntity handleFirebaseAuthException(FirebaseAuthException e){
        AuthErrorCode authErrorCode = e.getAuthErrorCode();
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage", authErrorCode.toString());
        return ResponseEntity.status(500).body(result);
    }

    @ExceptionHandler(value = {FirebaseMessagingException.class})
    protected ResponseEntity handleFirebaseMessagingException(FirebaseMessagingException e){
        MessagingErrorCode messagingErrorCode = e.getMessagingErrorCode();
        Map<String,String> result = new HashMap<>();
        result.put("ErrorMessage", messagingErrorCode.toString());
        return ResponseEntity.status(500).body(result);
    }
}
