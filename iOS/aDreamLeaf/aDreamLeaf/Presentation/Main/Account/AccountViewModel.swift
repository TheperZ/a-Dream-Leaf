//
//  AccountViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import Foundation
import RxSwift
import RxRelay

struct AccountViewModel {
    let disposeBag = DisposeBag()
    
    let refreshRequest = PublishSubject<Void>()
    
    let yearMonth = BehaviorSubject<Date>(value: Date.now)
    
    let list = PublishSubject<[Expenditure]>()
    
    init(_ repo: AccountRepository = AccountRepository()) {
        Observable.combineLatest(refreshRequest, yearMonth)
            .withLatestFrom(yearMonth)
            .map { Date.dateToString(with: $0, format: "yyyy-MM")}
            .flatMap(repo.getExpenditureList)
            .map { $0.data ?? [] }
            .bind(to: list)
            .disposed(by: disposeBag)
    }
}
