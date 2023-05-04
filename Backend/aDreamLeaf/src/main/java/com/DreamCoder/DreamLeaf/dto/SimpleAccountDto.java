package com.DreamCoder.DreamLeaf.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
@Builder
public class SimpleAccountDto {
    private int balance;
    private int charge;

    public void setCharge(int charge) {
        this.charge = charge;
    }
}
