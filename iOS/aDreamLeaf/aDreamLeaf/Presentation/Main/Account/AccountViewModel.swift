//
//  AccountViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import Foundation
import RxSwift
import RxRelay

struct AccountViewModel {
    let disposeBag = DisposeBag()
    
    let list = Observable.just([(Date(timeIntervalSinceNow: -250000), "백채 김치찌개", 12000), (Date(timeIntervalSinceNow: -220000), "할머니 순대국", 6000), (Date(timeIntervalSinceNow: -150000), "신전 떡볶이", 10000), (Date(timeIntervalSinceNow: -100000), "피자스쿨 목2동점", 8000)])
}
