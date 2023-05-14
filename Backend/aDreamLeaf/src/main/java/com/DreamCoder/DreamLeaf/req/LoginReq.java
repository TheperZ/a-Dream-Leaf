package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class LoginReq {
    private String firebaseToken;
}