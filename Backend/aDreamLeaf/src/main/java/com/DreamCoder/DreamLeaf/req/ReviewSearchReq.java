package com.DreamCoder.DreamLeaf.req;

import lombok.Data;
import lombok.Getter;
import lombok.ToString;

@Getter
@Data
@ToString
public class ReviewSearchReq {
    private int page;
    private int display;
}
