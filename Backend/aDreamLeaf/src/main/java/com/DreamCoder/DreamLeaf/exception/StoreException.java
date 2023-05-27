package com.DreamCoder.DreamLeaf.exception;

import lombok.Getter;

@Getter
public class StoreException extends RuntimeException{

    private int code;

    public StoreException() {
    }

    public StoreException(String message, int code) {
        super(message);
        this.code = code;
    }
}
