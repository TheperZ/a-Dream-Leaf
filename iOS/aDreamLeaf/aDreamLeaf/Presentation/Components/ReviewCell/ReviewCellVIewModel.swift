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
    var isMine: Bool {
        get {
            do {
                let user = try UserManager.getInstance().value()
                return user != nil && user!.userId == reviewerId
            } catch {
                return false
            }
        }
    }
    
    init(_ reviewData: Review) {
        self.reviewData = reviewData
        self.reviewId = reviewData.reviewId
        self.storeId = reviewData.storeId
        self.reviewerId = reviewData.userId
        self.nickname = reviewData.userName
        self.content = reviewData.body
        self.rating = reviewData.rating
        if let reviewImage = reviewData.reviewImage { // 리뷰에 사진이 포함된 경우
            self.image = Image.base64ToImg(with: reviewImage)
        } else {
            self.image = nil
        }
        
    }
}
