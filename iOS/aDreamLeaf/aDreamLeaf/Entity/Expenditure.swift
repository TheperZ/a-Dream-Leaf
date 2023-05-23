//
//  Expenditure.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/20.
//

import Foundation

class Expenditure: Decodable {
    let userId: Int
    let accountId: Int
    let restaurant: String
    let price: Int
    let date: String
    let body: String
}
