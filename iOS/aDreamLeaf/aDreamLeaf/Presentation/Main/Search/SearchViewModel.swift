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
    
    let allList = Observable.just([("피자스쿨 목2동점", 0.4, 4.5, true, true), ("다원레스토랑", 1.2, 4.9, true, false), ("할범탕수육 본점", 0.4, 4.2, false, true)])
    
    let tableItem = BehaviorSubject<[(String, Double, Double, Bool, Bool)]>(value: [("피자스쿨 목2동점", 0.4, 4.5, true, true), ("다원레스토랑", 1.2, 4.9, true, false), ("할범탕수육 본점", 0.4, 4.2, false, true)])
    
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
            .map { $0.filter { $0.3 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        goodButtonTap
            .withLatestFrom(allList)
            .map { $0.filter { $0.4 }}
            .bind(to: tableItem)
            .disposed(by: disposeBag)
        
        searchButtonTap.withLatestFrom(keyword)
            .flatMap(repo.searchStores)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
         
         
    }
}
