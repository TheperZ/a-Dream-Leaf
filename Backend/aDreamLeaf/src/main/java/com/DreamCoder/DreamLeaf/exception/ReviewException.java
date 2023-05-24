package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class ReviewException extends RuntimeException{
    private int code;
    public ReviewException(){
    }
    public ReviewException(String message, int code){
        super(message);
        this.code = code;
    }
}
