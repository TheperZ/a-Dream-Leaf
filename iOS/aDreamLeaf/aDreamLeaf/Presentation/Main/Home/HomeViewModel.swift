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
    let nearRests = Observable<[(name:String, rating:Double, distance: Double, good: Bool, card: Bool)]>.just([("브런치타임", 4.0, 130, true, true), ("조연탄", 4.3, 300, true, false), ("도라무통 즉석떡볶이", 4.1, 200, false, true)])
    
    let nearStores = PublishSubject<[SimpleStore]>()
    
    init(_ storeRepo: StoreRepository = StoreRepository()) {
        storeRepo
            .searchNearStore(lat: LocationManager.getTempLat(), long: LocationManager.getTempLogt())
            .map { $0.data ?? []}
            .map { $0.count > 2 ? Array($0[...2]) : $0 }
            .bind(to: nearStores)
            .disposed(by: disposeBag)
    }
    
}
