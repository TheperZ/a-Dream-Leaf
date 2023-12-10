//
//  SearchViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: StoreRepository
    
    struct Input {
        let keyword: Driver<String>
        let trigger: Driver<Void>
        let allTrigger: Driver<Void>
        let cardTrigger: Driver<Void>
        let goodTrigger: Driver<Void>
        let select: Driver<IndexPath>
    }
    
    struct Output {
        let stores: Driver<[SimpleStore]>
        let selectedStore: Driver<SimpleStore>
        let mode: Driver<Int>
    }
    
    init(_ repo: StoreRepository = NetworkStoreRepository()) {
        self.repository = repo
    }
    
    func tranform(input: Input) -> Output {
        let mode = BehaviorSubject(value: 2)
        input.goodTrigger.asObservable().map { 0 }.bind(to: mode).disposed(by: disposeBag)
        input.cardTrigger.asObservable().map { 1 }.bind(to: mode).disposed(by: disposeBag)
        input.allTrigger.asObservable().map { 2 }.bind(to: mode).disposed(by: disposeBag)
        
        let allStore = input.trigger
            .withLatestFrom(input.keyword)
            .flatMapLatest { keyword in
                repository.searchStores(with: keyword)
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
        
        return Output(stores: stores, selectedStore: selectedStore, mode: mode.asDriver(onErrorJustReturn: 2))
    }
}
