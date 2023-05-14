package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.MyPageDto;
import com.DreamCoder.DreamLeaf.dto.MyPageDelDto;


public interface MyPageRepository {

    public String delete(MyPageDelDto myPageDelDto);

    public MyPageDto inquire(String id);
}