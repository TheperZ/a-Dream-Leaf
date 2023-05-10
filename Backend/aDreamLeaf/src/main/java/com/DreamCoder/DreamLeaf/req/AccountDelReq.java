package com.DreamCoder.DreamLeaf.req;

import com.google.cloud.GcpLaunchStage;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class AccountDelReq {
    private String firebaseToken;
    private int accountId;
}
