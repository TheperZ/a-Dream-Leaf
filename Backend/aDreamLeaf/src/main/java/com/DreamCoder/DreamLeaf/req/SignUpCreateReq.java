package com.DreamCoder.DreamLeaf.req;

import lombok.Data;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDate;

@Data
@Getter
@ToString
public class SignUpCreateReq {
    private String firebaseToken;
    private String email;
}