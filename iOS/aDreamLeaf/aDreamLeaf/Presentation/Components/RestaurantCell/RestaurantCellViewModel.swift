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
    let type: Int
    
    init(data: SimpleStore) {
        self.name = data.storeName
        self.rating = data.totalRating
        self.distance = data.curDist
        self.type = data.storeType
    }
}
