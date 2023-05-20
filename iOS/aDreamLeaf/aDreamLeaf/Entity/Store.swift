//
//  Store.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation

class Store: Decodable {
    let storeId: Int
    let storeName: String
    let zipCode: Int
    let roadAddr: String
    let lotAddr: String
    let wgs84Lat: Double
    let wgs84Logt: Double
    let payment: Bool
    let prodName: String
    let prodTarget: String
}
