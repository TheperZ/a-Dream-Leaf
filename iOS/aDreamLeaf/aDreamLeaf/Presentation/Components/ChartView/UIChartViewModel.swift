//
//  UIChartViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift
import RxRelay

struct UIChartViewModel {
    private let disposeBag = DisposeBag()
    
    let dataValues = BehaviorSubject<[Int]>(value: [0, 0])
    
    let date = BehaviorSubject(value: Date.dateToString(with: Date.now, format:"yyyy-MM"))
    
    let refresh = BehaviorSubject<Void>(value: Void())
    
    init(_ repo: AccountRepository = AccountRepository()) {
        
        Observable.combineLatest(date, refresh)
            .flatMap{repo.getAccountSummary(yearMonth: $0.0)}
            .map { $0.data != nil ? [$0.data!.charge, $0.data!.balance] : [0,0]}
            .bind(to: dataValues)
            .disposed(by: disposeBag)

    }
    
}
