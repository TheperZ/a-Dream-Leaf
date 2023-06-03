package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class MyPageException extends RuntimeException{
    private int code;
    public MyPageException(){
    }

    public MyPageException(String message, int code) {
        super(message);
        this.code = code;
    }
}