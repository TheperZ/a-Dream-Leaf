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
    
    let allList = Observable.just([SimpleStore]())
    
    let tableItem = BehaviorSubject(value: [SimpleStore]())
    
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
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 2 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        goodButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 1 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
            
    }
}
