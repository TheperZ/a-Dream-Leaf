//
//  AccountRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/18.
//

import Foundation

class AccountRequest: Codable {
    
    init(token: String, restaurant: String, price: Int, date: String, body: String) {
        self.firebaseToken = token
        self.restaurant = restaurant
        self.price = price
        self.date = date
        self.body = body
    }
    
    let firebaseToken: String
    let restaurant: String
    let price: Int
    let date: String
    let body: String
    
    func toDict() -> [String: Any] {
        return ["firebaseToken": self.firebaseToken, "restaurant" : self.restaurant, "price" : price, "date": date, "body": body]
    }
}
