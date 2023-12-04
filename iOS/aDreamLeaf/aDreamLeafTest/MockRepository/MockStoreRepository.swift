//
//  MockStoreRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/4/23.
//


@testable import aDreamLeaf
import Foundation
import RxSwift

struct MockStoreRepository: StoreRepository {
    
    let simpleStores = [
        SimpleStore(storeId: 0, storeName: "피자", storeType: 0, curDist: 123, totalRating: 1.2),
        SimpleStore(storeId: 1, storeName: "치킨", storeType: 1, curDist: 234, totalRating: 2.3),
        SimpleStore(storeId: 2, storeName: "토스트", storeType: 1, curDist: 234, totalRating: 2.3),
        SimpleStore(storeId: 3, storeName: "편의점", storeType: 2, curDist: 345, totalRating: 3.4),
        SimpleStore(storeId: 4, storeName: "카페", storeType: 2, curDist: 456, totalRating: 4.5),
        SimpleStore(storeId: 5, storeName: "덮밥", storeType: 2, curDist: 456, totalRating: 4.5),
    ]
    
    let stores = [
        Store(storeId: 0, storeName: "피자", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 0, curDist: 123, totalRating: 1.2, hygieneGrade: ""),
        Store(storeId: 1, storeName: "치킨", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 1, curDist: 234, totalRating: 2.3, hygieneGrade: ""),
        Store(storeId: 2, storeName: "토스트", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 1, curDist: 234, totalRating: 2.3, hygieneGrade: ""),
        Store(storeId: 3, storeName: "편의점", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 2, curDist: 345, totalRating: 3.4, hygieneGrade: ""),
        Store(storeId: 4, storeName: "치킨", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 2, curDist: 234, totalRating: 2.3, hygieneGrade: ""),
        Store(storeId: 5, storeName: "덮밥", refinezipCd: 123, refineRoadnmAddr: "강서구", refineLotnoAddr: "강서구", refineWGS84Lat: 66.23, refineWGS84Logt: 126.65, storeType: 2, curDist: 456, totalRating: 4.5, hygieneGrade: ""),
    ]
    
    func searchStores(with keyword: String) -> RxSwift.Observable<[aDreamLeaf.SimpleStore]> {
        return Observable.just(simpleStores)
    }
    
    func fetchDetail(storeId: Int) -> RxSwift.Observable<aDreamLeaf.Store?> {
        return Observable.just(stores[storeId])
    }
    
    func searchNearStore(lat: Double, long: Double) -> RxSwift.Observable<[aDreamLeaf.SimpleStore]> {
        return Observable.just(simpleStores)
    }
    
    
}
