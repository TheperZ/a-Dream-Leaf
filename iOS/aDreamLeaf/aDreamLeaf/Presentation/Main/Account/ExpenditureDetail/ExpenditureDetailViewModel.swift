//
//  ExpenditureDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift
import RxCocoa

struct ExpenditureDetailViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AccountRepository
    private let expenditure: Expenditure
    
    struct Input {
        let deleteTrigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let expenditure: Expenditure
        let result: Driver<RequestResult<Void>>
    }
    
    init(data : Expenditure, _ repo: AccountRepository = AccountRepository()) {
        self.repository = repo
        self.expenditure = data
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.deleteTrigger
            .do(onNext: { loading.onNext(true) })
            .flatMapLatest {
                repository.deleteExpenditure(accountId: expenditure.accountId)
                    .do(onNext: { _ in loading.onNext(false) })
                    .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
            }
            
     
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), expenditure: expenditure, result: result)
    }
}
