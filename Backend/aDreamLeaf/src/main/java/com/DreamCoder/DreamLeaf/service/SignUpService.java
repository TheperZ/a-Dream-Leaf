package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.SignUpCreateDto;
import com.DreamCoder.DreamLeaf.dto.SignUpDto;
import com.DreamCoder.DreamLeaf.dto.LoginDto;
import com.DreamCoder.DreamLeaf.repository.SignUpRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class SignUpService {

    private final SignUpRepository SignUpRepositoryImpl;

    /*public SignUpDto create(SignUpCreateDto signUpCreateDto){
        return SignUpRepositoryImpl.save(signUpCreateDto);
    }*/
    public String create(SignUpCreateDto signUpCreateDto){
        return SignUpRepositoryImpl.save(signUpCreateDto);
    }

    public LoginDto loginInquire(int id){
        return SignUpRepositoryImpl.inquire(id);
    }
}