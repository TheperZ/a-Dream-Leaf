//
//  StoreRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol StoreRepository {
    func searchStores(with keyword: String) -> Observable<[SimpleStore]>
    func fetchDetail(storeId: Int) -> Observable<Store?>
    func searchNearStore(lat: Double, long: Double) -> Observable<[SimpleStore]>
}
