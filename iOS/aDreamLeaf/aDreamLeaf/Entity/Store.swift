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
    let refinezipCd: Int
    let refineRoadnmAddr: String
    let refineLotnoAddr: String
    let refineWGS84Lat: Double
    let refineWGS84Logt: Double
    let prodName: String
    let prodTarget: String
    let storeType: Int
    let curDist: Double
    let totalRating: Double
    let hygieneGrade: String
}

class SimpleStore: Decodable {
    let storeId: Int
    let storeName: String
    let storeType: Int
    let curDist: Double
    let totalRating: Double
}
