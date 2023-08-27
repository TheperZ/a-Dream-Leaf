//
//  NewPaymentViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxRelay

struct NewPaymentViewModel: LoadingViewModel {
    var loading: PublishSubject<Bool>
    var disposeBag = DisposeBag()
    let editData: Expenditure?
    
    let date = BehaviorSubject<String>(value: Date.dateToString(with: Date.now))
    let storeName = BehaviorSubject<String>(value: "")
    let body = BehaviorSubject<String>(value: "")
    let price = PublishSubject<Int>()
    
    let saveBtnTap = PublishRelay<Void>()
    
    let saveResult = PublishSubject<RequestResult<Void>>()
    
    init(_ repo: AccountRepository = AccountRepository(), data: Expenditure? = nil) {
        loading = PublishSubject<Bool>()
        
        // New
        editData = data
        
        if data == nil {
            saveBtnTap
                .withLatestFrom(Observable.combineLatest(date, storeName, body, price))
                .flatMap(repo.createRequest)
                .bind(to: saveResult)
                .disposed(by: disposeBag)
            
            saveBtnTap
                .map { true }
                .bind(to: loading)
                .disposed(by: disposeBag)
            
            saveResult
                .map { _ in false }
                .bind(to: loading)
                .disposed(by: disposeBag)
        }
        
        // Update
        
        if let data = data {
            saveBtnTap
                .withLatestFrom(Observable.combineLatest(date, storeName, body, price))
                .flatMap{ date, storeName, body, price in
                    return repo.updateRequest(accountId: data.accountId, date: date, storeName: storeName, body: body, price: price)
                }
                .bind(to: saveResult)
                .disposed(by: disposeBag)
            
            saveBtnTap
                .map { true }
                .bind(to: loading)
                .disposed(by: disposeBag)

            saveResult
                .map { _ in false }
                .bind(to: loading)
                .disposed(by: disposeBag)
        }
    }
}
