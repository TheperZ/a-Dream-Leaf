//
//  Expenditure.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/20.
//

import Foundation

class Expenditure: Decodable {
    init(userId: Int, accountId: Int, restaurant: String, price: Int, date: String, body: String) {
        self.userId = userId
        self.accountId = accountId
        self.restaurant = restaurant
        self.price = price
        self.date = date
        self.body = body
    }
    
    let userId: Int
    let accountId: Int
    let restaurant: String
    let price: Int
    let date: String
    let body: String
}
