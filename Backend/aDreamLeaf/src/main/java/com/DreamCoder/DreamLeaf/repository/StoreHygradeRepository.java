package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.domain.StoreHygrade;
import com.DreamCoder.DreamLeaf.dto.StoreHygradeDto;
import com.DreamCoder.DreamLeaf.req.StoreHygradeReq;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface StoreHygradeRepository extends JpaRepository<StoreHygrade, Long> {
}
