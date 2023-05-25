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
    
    func searchStores(with keyword: String) -> Observable<RequestResult<[SimpleStore]>> {
        return network.searchStore(with: keyword)
    }
    
    func fetchDetail(storeId: Int) -> Observable<RequestResult<Store>> {
        return network.fetchStoreDetail(storeId: storeId)
    }
    
    func searchNearStore(lat: Double, long: Double) -> Observable<RequestResult<[SimpleStore]>> {
        return network.searchWithLocation(lat: lat, long: long)
    }
}
