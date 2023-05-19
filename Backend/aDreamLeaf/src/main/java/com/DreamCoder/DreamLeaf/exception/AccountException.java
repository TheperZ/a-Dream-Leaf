package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class AccountException extends RuntimeException{
    private int code;
    public AccountException(){
    }

    public AccountException(String message, int code) {
        super(message);
        this.code = code;
    }
}
