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
        let result: Driver<Result<Void, Error>>
        let editData: Expenditure?
    }
    
    
    init(_ repo: AccountRepository = NetworkAccountRepository(), data: Expenditure? = nil) {
        self.repository = repo
        self.editData = data
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let date = BehaviorSubject<Date>(value: .now)
        input.date.drive(date).disposed(by: disposeBag)
        
        let store = BehaviorSubject<String>(value: "")
        input.store.drive(store).disposed(by: disposeBag)
        
        let content = BehaviorSubject<String>(value: "")
        input.content.drive(content).disposed(by: disposeBag)
        
        let cost =  BehaviorSubject<Int>(value: -1)
        input.cost.drive(cost).disposed(by: disposeBag)
        
        if let editData = editData {
            date.onNext(Date.stringToDate(str: editData.date)!)
            store.onNext(editData.restaurant)
            content.onNext(editData.body)
            cost.onNext(editData.price)
        }
        
        let result = input.trigger
            .asObservable()
            .withLatestFrom(Observable.combineLatest(date, store, content, cost))
            .do(onNext: { _ in loading.onNext(true) })
            .flatMapLatest { (date, store, content, cost) in
                
                let dateString = Date.dateToString(with: date)
                
                if let editData = editData {
                    return repository.updateRequest(accountId: editData.accountId, date: dateString, storeName: store, body: content, price: cost)
                        .asDriver(onErrorJustReturn: .success(()))
                        .do(onNext: { _ in loading.onNext(false)} )
                } else {
                    return repository.createRequest(date: dateString, storeName: store, body: content, price: cost)
                        .asDriver(onErrorJustReturn: .success(()))
                        .do(onNext: { _ in loading.onNext(false)} )
                }
                
            }
            .asDriver(onErrorJustReturn: .success(()))
        
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result, editData: editData)
    }
}
