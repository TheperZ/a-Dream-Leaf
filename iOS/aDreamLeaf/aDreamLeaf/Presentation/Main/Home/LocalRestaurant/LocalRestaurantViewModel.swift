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
    
    let allList = Observable.just([("피자스쿨 목2동점", 0.4, 4.5, true, true), ("다원레스토랑", 1.2, 4.9, true, false), ("할범탕수육 본점", 0.4, 4.2, false, true)])
    
    let tableItem = BehaviorSubject<[(String, Double, Double, Bool, Bool)]>(value: [("피자스쿨 목2동점", 0.4, 4.5, true, true), ("다원레스토랑", 1.2, 4.9, true, false), ("할범탕수육 본점", 0.4, 4.2, false, true)])
    
    let allButtonTap = PublishRelay<Void>()
    let cardButtonTap = PublishRelay<Void>()
    let goodButtonTap = PublishRelay<Void>()
    
    init(_ repo: KakaoRepositroy = KakaoRepositroy()) {
        
        address.distinctUntilChanged()
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        if LocationManager.permitionCheck() {
            Observable.just((LocationManager.getLatitude(), LocationManager.getLongitude()))
                .filter{ (lat: Double?, lon: Double?) in
                    return lat != nil && lon != nil
                }
                .map { ($0.0!, $0.1!) }
                .flatMap(repo.getAddressKakao)
                .bind(to: address)
                .disposed(by: disposeBag)
        } else {
            address.accept("GPS 권한을 설정해주세요!")
        }
        
        allButtonTap
            .withLatestFrom(allList)
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        cardButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.3 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        goodButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.4 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
            
    }
}
