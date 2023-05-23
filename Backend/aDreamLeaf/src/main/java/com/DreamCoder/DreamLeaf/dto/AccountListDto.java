package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class AccountListDto {
    private int id;
    private String yearMonth;
}
