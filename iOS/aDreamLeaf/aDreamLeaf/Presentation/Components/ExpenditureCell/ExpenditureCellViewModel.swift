//
//  ExpenditureCellViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import Foundation
import RxSwift
import RxRelay

struct ExpenditureCellViewModel {
    let disposeBag = DisposeBag()
    
    let date: String
    let title: String
    let cost: Int
    let body: String
    
    init(expenditure: Expenditure) {
        self.date = String(expenditure.date.replacingOccurrences(of: "-", with: ".")[expenditure.date.index(expenditure.date.startIndex, offsetBy: 5)...])+"."
        self.title = expenditure.restaurant
        self.cost = expenditure.price
        self.body = expenditure.body
    }
}
