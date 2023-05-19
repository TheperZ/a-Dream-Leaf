package com.DreamCoder.DreamLeaf.exhandler;

import com.DreamCoder.DreamLeaf.exception.AccountException;
import com.DreamCoder.DreamLeaf.exception.AlarmException;
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
}
