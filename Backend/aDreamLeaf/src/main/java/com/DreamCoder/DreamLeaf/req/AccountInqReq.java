package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Data
public class AccountInqReq {
    private String firebaseToken;
    private String yearMonth;
}
