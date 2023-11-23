//
//  NewPaymentViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa

struct NewPaymentViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AccountRepository
    private let editData: Expenditure?
    
    struct Input {
        let trigger: Driver<Void>
        let date: Driver<Date>
        let store: Driver<String>
        let content: Driver<String>
        let cost: Driver<Int>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let result: Driver<RequestResult<Void>>
        let editData: Expenditure?
    }
    
    
    init(_ repo: AccountRepository = AccountRepository(), data: Expenditure? = nil) {
        self.repository = repo
        self.editData = data
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.trigger
            .withLatestFrom(Driver.combineLatest(input.date, input.store, input.content, input.cost))
            .do(onNext: { _ in loading.onNext(true) })
            .flatMapLatest { (date, store, content, cost) in
                
                let dateString = Date.dateToString(with: date)
                
                if let editData = editData {
                    return repository.updateRequest(accountId: editData.accountId, date: dateString, storeName: store, body: content, price: cost)
                        .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
                        .do(onNext: { _ in loading.onNext(false)} )
                } else {
                    return repository.createRequest(date: dateString, storeName: store, body: content, price: cost)
                        .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
                        .do(onNext: { _ in loading.onNext(false)} )
                }
                
            }
        
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result, editData: editData)
    }
}
