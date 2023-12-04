//
//  HomeViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel {
    private let disposeBag = DisposeBag()
    private let repository: StoreRepository
    
    struct Input {
        let trigger: Driver<Void>
        let selectStore: Driver<IndexPath>
    }
    
    struct Output {
        let nearStores: Driver<[SimpleStore]>
        let selectedStore: Driver<SimpleStore>
        let login: Driver<Bool>
    }
    
    init(_ storeRepo: StoreRepository = NetworkStoreRepository()) {
        self.repository = storeRepo
    }
    
    func transform(input: Input) -> Output {
        let nearStore = input.trigger
            .flatMapLatest {
                repository.searchNearStore(lat: LocationManager.getLatitude(), long: LocationManager.getLatitude())
                    .asDriver(onErrorJustReturn: [])
            }
        
        let selectedStore = input.selectStore
            .withLatestFrom(nearStore) { indexPath, list in list[indexPath.row] }
        
        let login = UserManager.getInstance()
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        return Output(nearStores: nearStore, selectedStore: selectedStore, login: login)
    }
    
}
