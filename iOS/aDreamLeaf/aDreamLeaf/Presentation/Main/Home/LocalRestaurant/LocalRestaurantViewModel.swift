//
//  LocalRestaurantViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/03.
//

import Foundation
import RxSwift
import RxRelay

struct LocalRestaurantViewModel {
    private let disposeBag = DisposeBag()
    let list = Observable.just([("피자스쿨 목2동점", 0.4, 4.5, true, true), ("다원레스토랑", 1.2, 4.9, true, false), ("할범탕수육 본점", 0.4, 4.2, false, true)])
}
