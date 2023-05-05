package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;

public interface SignUpRepository {
    public SignUpDto save(SignUpCreateDto signUpCreateDto);
}