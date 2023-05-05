package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@Getter
@ToString
@Builder
public class SignUpDto {
    private int uid;
    private String email;
    private int userId;
}
