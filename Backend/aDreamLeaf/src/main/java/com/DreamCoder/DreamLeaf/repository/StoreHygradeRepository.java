package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.StoreHygradeDto;
import com.DreamCoder.DreamLeaf.req.StoreHygradeReq;

import java.util.Optional;


public interface StoreHygradeRepository {



    public Optional<StoreHygradeDto> save(StoreHygradeReq storeHygieneReq);
}
