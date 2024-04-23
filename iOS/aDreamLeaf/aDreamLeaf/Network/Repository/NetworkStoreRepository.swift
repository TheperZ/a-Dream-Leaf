//
//  StoreRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift

struct NetworkStoreRepository: StoreRepository {
    private let network = StoreNetwork()
    
    func searchStores(with keyword: String) -> Observable<[SimpleStore]> {
        return network.searchStore(with: keyword)
            .map { result in
                switch result {
                    case let .success(data):
                        return data
                    case .failure(let failure):
                        return []
                }}
            
    }
    
    func fetchDetail(storeId: Int) -> Observable<Store?> {
        return network.fetchStoreDetail(storeId: storeId)
            .map { result in
                switch result {
                    case let .success(data):
                        return data
                    case .failure:
                        return nil
                }
            }
            
    }
    
    func searchNearStore(lat: Double, long: Double) -> Observable<[SimpleStore]> {
        return network.searchWithLocation(lat: lat, long: long)
            .map { result in
                switch result {
                    case let .success(data):
                        return data
                    case .failure(let failure):
                        return []
                }}
    }
}
