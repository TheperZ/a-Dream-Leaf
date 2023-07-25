//
//  HomeViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import Foundation
import RxSwift
import RxRelay

struct HomeViewModel {
    let disposeBag = DisposeBag()
    
    let nearStores = PublishSubject<[SimpleStore]>()
    
    init(_ storeRepo: StoreRepository = StoreRepository()) {
        storeRepo
            .searchNearStore(lat: LocationManager.getLatitude() ?? 0.0, long: LocationManager.getLongitude() ?? 0.0)
            .map { $0.data ?? []}
            .map { $0.count > 2 ? Array($0[...2]) : $0 }
            .bind(to: nearStores)
            .disposed(by: disposeBag)
    }
    
}
