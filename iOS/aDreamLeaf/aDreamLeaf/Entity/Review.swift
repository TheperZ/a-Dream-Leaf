//
//  Review.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation

class Review: Decodable {
    init(userId: Int, userName: String, reviewId: Int, storeId: Int, storeName: String, date: String, body: String, rating: Int, reviewImage: String? = nil) {
        self.userId = userId
        self.userName = userName
        self.reviewId = reviewId
        self.storeId = storeId
        self.storeName = storeName
        self.date = date
        self.body = body
        self.rating = rating
        self.reviewImage = reviewImage
    }
    
    
    let userId: Int
    let userName: String
    let reviewId: Int
    let storeId: Int
    let storeName: String
    let date: String
    let body: String
    let rating: Int
    let reviewImage: String?
     
}
