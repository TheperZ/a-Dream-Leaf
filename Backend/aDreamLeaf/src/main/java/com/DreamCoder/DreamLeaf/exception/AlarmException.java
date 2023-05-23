package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class AlarmException extends RuntimeException {
    private int code;
    public AlarmException(){
    }
    public AlarmException(String message, int code){
        super(message);
        this.code = code;
    }
}
