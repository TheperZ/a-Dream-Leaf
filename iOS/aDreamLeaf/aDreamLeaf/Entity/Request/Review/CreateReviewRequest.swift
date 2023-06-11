//
//  CreateReviewRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import UIKit

class CreateReviewRequest {
    
    let reviewBody: ReviewBody
    let reviewImage: UIImage?
    
    init(firebaseToken: String, storeId: Int, date: Date, body: String, rating: Int, image: UIImage? = nil) {
        self.reviewBody = ReviewBody(firebaseToken: firebaseToken, storeId: storeId, date: date, body: body, rating: rating)
        self.reviewImage = image;
    }
    
    class ReviewBody {
        
        init(firebaseToken: String, storeId: Int, date: Date, body: String, rating: Int) {
            self.firebaseToken = firebaseToken
            self.storeId = storeId
            self.date = Date.dateToString(with: Date.now, format: "yyyy-MM-dd HH:mm:ss")
            self.body = body
            self.rating = rating
        }
        
        let firebaseToken: String
        let storeId: Int
        let date: String
        let body: String
        let rating: Int
        
        func toDict() -> [String: Any] {
            return [
                "firebaseToken": firebaseToken,
                "storeId": storeId,
                "date": date,
                "reviewBody": body,
                "rating": rating
            ]
        }
    }
    
    func toDict() -> [String: Any] {
        return [
            "reviewBody": self.reviewBody.toDict(),
            "reviewImage": self.reviewImage
        ]
    }
    
    
}
