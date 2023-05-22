//
//  NewPaymentViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxRelay

struct NewPaymentViewModel {
    let disposeBag = DisposeBag()
    
    let loading = BehaviorSubject<Bool>(value: false)
    
    let date = BehaviorSubject<String>(value: Date.dateToString(with: Date.now))
    let storeName = BehaviorSubject<String>(value: "")
    let body = BehaviorSubject<String>(value: "")
    let price = PublishSubject<Int>()
    
    let saveBtnTap = PublishRelay<Void>()
    
    let createResult = PublishSubject<RequestResult<Void>>()
    
    init(_ repo: AccountRepository = AccountRepository()) {
        
        saveBtnTap
            .withLatestFrom(Observable.combineLatest(date, storeName, body, price))
            .flatMap(repo.createRequest)
            .bind(to: createResult)
            .disposed(by: disposeBag)
        
        
        saveBtnTap
            .map { true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        createResult
            .map { _ in false }
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
}
