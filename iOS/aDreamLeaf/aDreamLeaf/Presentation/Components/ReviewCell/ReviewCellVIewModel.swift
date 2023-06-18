//
//  ReviewCellVIewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewCellVIewModel {
    let disposeBag = DisposeBag()
    let reviewData: Review
    let reviewId: Int
    let storeId: Int
    let reviewerId: Int
    let nickname: String
    let content: String
    let rating: Int
    let image: UIImage?
    
    init(_ reviewData: Review) {
        self.reviewData = reviewData
        self.reviewId = reviewData.reviewId
        self.storeId = reviewData.storeId
        self.reviewerId = reviewData.userId
        self.nickname = reviewData.userName
        self.content = reviewData.body
        self.rating = reviewData.rating
//        self.image = reviewData.imageUrl
        self.image = nil
    }
}
