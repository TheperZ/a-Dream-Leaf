//
//  ExpenditureDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift
import RxRelay

struct ExpenditureDetailViewModel {
    private let disposeBag = DisposeBag()
    
    let loading = BehaviorSubject<Bool>(value: false)
    
    let data: BehaviorSubject<Expenditure>
    private let expenditureId: Int
    
    let deleteButtonTap = PublishRelay<Void>()
    let deleteResult = PublishSubject<RequestResult<Void>>()
    
    init(data : Expenditure, _ repo: AccountRepository = AccountRepository()) {
        self.data = BehaviorSubject(value: data)
        self.expenditureId = data.accountId
        
        deleteButtonTap
            .flatMap{ repo.deleteExpenditure(accountId: data.accountId) }
            .bind(to: deleteResult)
            .disposed(by: disposeBag)
        
        //MARK: - Loading
        
        deleteButtonTap
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        deleteResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
}
