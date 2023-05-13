package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@Getter
@ToString
@Builder
public class SignUpDto {
    private int userId;
    private String uid;
    private String userName;
    private String email;

}
