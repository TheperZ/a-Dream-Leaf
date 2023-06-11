//
//  Review.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation

class Review: Decodable {
    
    let userId: Int
    let userName: String
    let reviewId: Int
    let storeId: Int
    let storeName: String
    let date: String
    let body: String
    let rating: Int
    let imageUrl: String?
     
}
