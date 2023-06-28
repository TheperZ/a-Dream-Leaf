//
//  CreateReviewRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import UIKit

class CreateReviewRequest {
    
    let firebaseToken: String
    let storeId: Int
    let date: String
    let body: String
    let rating: Int
    let reviewImage: String?
    
    init(firebaseToken: String, storeId: Int, date: Date, body: String, rating: Int, image: UIImage?) {
        self.firebaseToken = firebaseToken
        self.storeId = storeId
        self.date = Date.dateToString(with: Date.now, format: "yyyy-MM-dd HH:mm:ss")
        self.body = body
        self.rating = rating
        
        if let image = image { // 이미지가 포함되어있는 경우
            let imageData:NSData = image.pngData()! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            self.reviewImage = strBase64
        } else { // 이미지가 포함되지 않은 경우
            self.reviewImage = nil
        }
        
    }
    
    
    
    func toDict() -> [String: Any] {
        return [
            "firebaseToken": firebaseToken,
            "storeId": storeId,
            "date": date,
            "body": body,
            "rating": rating,
            "reviewImage": reviewImage
        ]
    }
    
    
}
