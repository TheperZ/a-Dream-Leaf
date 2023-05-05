package com.DreamCoder.DreamLeaf.dto;

import lombok.*;

@Data
@AllArgsConstructor
@Getter
@Builder
public class SignUpCreateDto {
    private String email;
    private int userId;
}
