package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface StoreRepository extends JpaRepository<Store, Long>, StoreRepositoryCustom {
    public boolean existsByStoreNameAndWgs84LatAndWgs84Logt(String name, double wgs84Lat, double wgs84Logt);

    @Query(value = "select * from store where storeName like ? order by (select avg(rating) from review where review.storeId=store.storeId) desc",
            nativeQuery = true)
    List<Store> findByKeyword(String keyword);
}
