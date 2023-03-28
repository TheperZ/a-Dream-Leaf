//
//  HomeViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import Foundation
import RxSwift
import RxRelay

struct HomeViewModel {
    let disposeBag = DisposeBag()
    let nearRests = Observable<[(name:String, rating:Double, distance: Double)]>.just([("브런치타임", 4.0, 130), ("조연탄", 4.3, 300), ("도라무통 즉석떡볶이", 4.1, 200)])
}
