//
//  RestaurantCellViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import Foundation
import RxSwift
import RxRelay

struct RestaurantCellViewModel {
    let disposeBag = DisposeBag()
    let name: String
    let rating: Double
    let distance: Double
    
    init(name: String, rating: Double, distance: Double) {
        self.name = name
        self.rating = rating
        self.distance = distance
    }
}
