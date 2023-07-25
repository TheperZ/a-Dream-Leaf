//
//  LocalRestaurantViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/03.
//

import Foundation
import RxSwift
import RxRelay

struct LocalRestaurantViewModel {
    private let disposeBag = DisposeBag()
    
    let loading = BehaviorSubject<Bool>(value: true)
    
    let address = BehaviorRelay<String>(value: "")
    
    let allList = BehaviorSubject<[SimpleStore]>(value: [])
    
    let tableItem = BehaviorSubject(value: [SimpleStore]())
    
    let allButtonTap = PublishRelay<Void>()
    let cardButtonTap = PublishRelay<Void>()
    let goodButtonTap = PublishRelay<Void>()
    
    init(_ kakaoRepo: KakaoRepositroy = KakaoRepositroy(), _ storeRepo: StoreRepository = StoreRepository()) {
        
        address.distinctUntilChanged()
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
//        if LocationManager.permitionCheck() {
//            Observable.just((LocationManager.getLatitude(), LocationManager.getLongitude()))
//                .filter{ (lat: Double?, lon: Double?) in
//                    return lat != nil && lon != nil
//                }
//                .map { ($0.0!, $0.1!) }
//                .flatMap(repo.getAddressKakao)
//                .bind(to: address)
//                .disposed(by: disposeBag)
//        } else {
//            address.accept("GPS 권한을 설정해주세요!")
//        }
        
        
        Observable.just((LocationManager.getLatitude() ?? 0.0 , LocationManager.getLongitude() ?? 0.0))
            .map { ($0.0, $0.1) }
            .flatMap(kakaoRepo.getAddressKakao)
            .bind(to: address)
            .disposed(by: disposeBag)
        
        allButtonTap
            .withLatestFrom(allList)
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        cardButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 2 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        goodButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 1 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        allList
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        storeRepo.searchNearStore(lat: LocationManager.getLatitude() ?? 0.0, long: LocationManager.getLongitude() ?? 0.0 )
            .map { $0.data ?? [] }
            .bind(to: allList)
            .disposed(by: disposeBag)
        
    }
}
