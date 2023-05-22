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
    
    init(_ repo: AccountRepository = AccountRepository()) {
        
        date
            .flatMap(repo.getAccountSummary)
            .map { $0.data != nil ? [$0.data!.charge, $0.data!.balance] : [0,0]}
            .bind(to: dataValues)
            .disposed(by: disposeBag)

    }
    
}
