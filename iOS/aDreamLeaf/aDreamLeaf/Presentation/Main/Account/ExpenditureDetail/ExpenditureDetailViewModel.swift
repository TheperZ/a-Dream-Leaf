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
    
    let data: BehaviorSubject<Expenditure>
    private let expenditureId: Int
    
    init(data : Expenditure) {
        self.data = BehaviorSubject(value: data)
        self.expenditureId = data.accountId
    }
}
