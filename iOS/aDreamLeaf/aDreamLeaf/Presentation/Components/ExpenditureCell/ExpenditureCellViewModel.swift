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
    
    init(date: String, title: String, cost: Int, body: String) {
        self.date = String(date.replacingOccurrences(of: "-", with: ".")[date.index(date.startIndex, offsetBy: 5)...])
        self.title = title
        self.cost = cost
        self.body = body
    }
}
