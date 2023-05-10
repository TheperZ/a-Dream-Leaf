package com.DreamCoder.DreamLeaf.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class AccountListReq {
    private String firebaseToken;
    private String yearMonth;
}
