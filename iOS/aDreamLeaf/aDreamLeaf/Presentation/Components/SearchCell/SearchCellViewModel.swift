//
//  SearchCellViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/31.
//

import Foundation
import RxSwift
import RxRelay

struct SearchCellViewModel {
    let disposeBag = DisposeBag()
    let name: String
    let distance: Double
    let rating: Double
    let card: Bool
    let good: Bool
    
    init(name: String, distance: Double, rating: Double, card: Bool, good: Bool) {
        self.name = name
        self.distance = distance
        self.rating = rating
        self.card = card
        self.good = good
    }
}
