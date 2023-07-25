//
//  SearchViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxRelay

struct SearchViewModel {
    let disposeBag = DisposeBag()
    
    let keyword = BehaviorRelay(value: "")
    let searchButtonTap = BehaviorRelay(value: Void())
    
    let allList = BehaviorSubject<[SimpleStore]>(value: [])
    
    let tableItem = BehaviorSubject<[SimpleStore]>(value: [])
    
    let allButtonTap = PublishRelay<Void>()
    let cardButtonTap = PublishRelay<Void>()
    let goodButtonTap = PublishRelay<Void>()
    
    init(_ repo: StoreRepository = StoreRepository()) {
        allButtonTap
            .withLatestFrom(allList)
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        cardButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 1 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        goodButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.storeType == 0 || $0.storeType == 2 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        searchButtonTap.withLatestFrom(keyword)
            .flatMap(repo.searchStores)
            .map { $0.data ?? [] }
            .bind(to: allList)
            .disposed(by: disposeBag)
        
        allList
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
         
         
    }
}
