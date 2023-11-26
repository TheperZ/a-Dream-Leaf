//
//  StoreRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift

struct StoreRepository {
    private let network = StoreNetwork()
    
    func searchStores(with keyword: String) -> Observable<[SimpleStore]> {
        return network.searchStore(with: keyword)
            .map { result in result.data ?? []}
    }
    
    func fetchDetail(storeId: Int) -> Observable<Store?> {
        return network.fetchStoreDetail(storeId: storeId)
            .map { $0.data }
    }
    
    func searchNearStore(lat: Double, long: Double) -> Observable<[SimpleStore]> {
        return network.searchWithLocation(lat: lat, long: long)
            .map { result in result.data ?? []}
    }
}
