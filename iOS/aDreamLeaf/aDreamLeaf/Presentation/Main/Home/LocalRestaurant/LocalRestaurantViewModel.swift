//
//  LocalRestaurantViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/03.
//

import Foundation
import RxSwift
import RxCocoa

struct LocalRestaurantViewModel {
    private let disposeBag = DisposeBag()
    private let kakaoRepo: KakaoRepositroy
    private let storeRepo: StoreRepository
    
    struct Input {
        let trigger: Driver<Void>
        let allTrigger: Driver<Void>
        let cardTrigger: Driver<Void>
        let goodTrigger: Driver<Void>
        let select: Driver<IndexPath>
    }
    
    struct Output {
        let address: Driver<String>
        let stores: Driver<[SimpleStore]>
        let selectedStore: Driver<SimpleStore>
        let mode: Driver<Int>
    }
    
    init(_ kakaoRepo: KakaoRepositroy = KakaoRepositroy(), _ storeRepo: StoreRepository = StoreRepository()) {
        self.kakaoRepo = kakaoRepo
        self.storeRepo = storeRepo
    }
    
    func transform(input: Input) -> Output {
        let address = input.trigger
            .flatMapLatest {
                kakaoRepo.getMyAddress()
                    .asDriver(onErrorJustReturn: "")
            }
        
        let mode = BehaviorSubject(value: 2)
        input.goodTrigger.asObservable().map { 0 }.bind(to: mode).disposed(by: disposeBag)
        input.cardTrigger.asObservable().map { 1 }.bind(to: mode).disposed(by: disposeBag)
        input.allTrigger.asObservable().map { 2 }.bind(to: mode).disposed(by: disposeBag)
        
        let allStore = input.trigger
            .flatMapLatest {
                storeRepo.searchNearStore(lat: LocationManager.getLatitude(), long: LocationManager.getLongitude())
                    .asDriver(onErrorJustReturn: [])
            }
        
        let stores = Driver.combineLatest(allStore, mode.asDriver(onErrorJustReturn: 2)).map { store, mode in
            if mode == 0 {
                return store.filter { $0.storeType == 2 || $0.storeType == 0 }
            } else if mode == 1 {
                return store.filter {  $0.storeType == 2 || $0.storeType == 1 }
            } else {
                return store
            }
        }
        
        let selectedStore = input.select.withLatestFrom(stores) { indexPath, stores in stores[indexPath.row] }
        
        return Output(address: address, stores: stores, selectedStore: selectedStore, mode: mode.asDriver(onErrorJustReturn: 2))
    }
}
