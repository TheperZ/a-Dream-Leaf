package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface StoreRepository extends JpaRepository<Store, Long>, StoreRepositoryCustom {
    public boolean existsByStoreNameAndWgs84LatAndWgs84Logt(String name, double wgs84Lat, double wgs84Logt);

    @Query(value = "select * from store where storeName like %:keyword% order by (select avg(rating) from review where review.storeId=store.storeId) desc",
            nativeQuery = true)
    List<Store> findByKeyword(String keyword);


    @Query(value = "select *, (6371*acos(cos(radians(?))*cos(radians(:wgs84Lat))*cos(radians(:wgs84Logt)" +
            "-radians(?))+sin(radians(?))*sin(radians(:wgs84Lat))))" +
            "AS distance, (select avg(rating) from review where review.storeId=store.storeId) as totalRating from store having distance<2 order by distance", nativeQuery = true)
    List<Store> findByCur(double wgs84Lat, double wgs84Logt);
}
