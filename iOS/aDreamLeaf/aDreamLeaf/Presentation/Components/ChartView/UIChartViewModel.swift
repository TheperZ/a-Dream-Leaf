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
    
    let fetchDataRequest = PublishSubject<Void>()
    
    init(_ repo: AccountRepository = AccountRepository()) {
        
        fetchDataRequest
            .flatMap(repo.getAccountSummary)
            .map { $0.summary != nil ? [$0.summary!.charge, $0.summary!.balance] : [0,0]}
            .bind(to: dataValues)
            .disposed(by: disposeBag)

    }
    
}
