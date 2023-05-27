package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class SignUpException extends RuntimeException{
    private int code;
    public SignUpException(){
    }

    public SignUpException(String message, int code) {
        super(message);
        this.code = code;
    }
}