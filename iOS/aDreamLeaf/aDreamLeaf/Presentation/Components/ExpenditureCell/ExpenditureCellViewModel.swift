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
    
    let date: Date
    let title: String
    let cost: Int
}
