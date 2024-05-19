package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StoreRepository extends JpaRepository<Store, Long>, StoreRepositoryCustom {
    public boolean existsByStoreNameAndWgs84LatAndWgs84Logt(String name, double wgs84Lat, double wgs84Logt);
}
