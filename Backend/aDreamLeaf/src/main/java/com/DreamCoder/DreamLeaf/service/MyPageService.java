package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;
import com.DreamCoder.DreamLeaf.repository.MyPageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class MyPageService {

    @Autowired
    private final MyPageRepository MyPageRepositoryImpl;
    public String delete(MyPageDelDto myPageDelDto){
        return MyPageRepositoryImpl.delete(myPageDelDto);
    }

}