package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;
import com.DreamCoder.DreamLeaf.dto.LoginDto;

public interface SignUpRepository {
    //public SignUpDto save(SignUpCreateDto signUpCreateDto);
    public String save(SignUpCreateDto signUpCreateDto);

    public LoginDto inquire(int id);
}