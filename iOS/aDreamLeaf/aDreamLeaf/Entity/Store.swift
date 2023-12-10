//
//  Store.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation

class Store: Decodable {
    init(storeId: Int, storeName: String, refinezipCd: Int, refineRoadnmAddr: String, refineLotnoAddr: String, refineWGS84Lat: Double, refineWGS84Logt: Double, prodName: String? = nil, prodTarget: String? = nil, storeType: Int, curDist: Double, totalRating: Double, hygieneGrade: String) {
        self.storeId = storeId
        self.storeName = storeName
        self.refinezipCd = refinezipCd
        self.refineRoadnmAddr = refineRoadnmAddr
        self.refineLotnoAddr = refineLotnoAddr
        self.refineWGS84Lat = refineWGS84Lat
        self.refineWGS84Logt = refineWGS84Logt
        self.prodName = prodName
        self.prodTarget = prodTarget
        self.storeType = storeType
        self.curDist = curDist
        self.totalRating = totalRating
        self.hygieneGrade = hygieneGrade
    }
    
    let storeId: Int
    let storeName: String
    let refinezipCd: Int
    let refineRoadnmAddr: String
    let refineLotnoAddr: String
    let refineWGS84Lat: Double
    let refineWGS84Logt: Double
    let prodName: String?
    let prodTarget: String?
    let storeType: Int
    let curDist: Double
    let totalRating: Double
    let hygieneGrade: String
}

class SimpleStore: Decodable {
    init(storeId: Int, storeName: String, storeType: Int, curDist: Double, totalRating: Double) {
        self.storeId = storeId
        self.storeName = storeName
        self.storeType = storeType
        self.curDist = curDist
        self.totalRating = totalRating
    }
    
    let storeId: Int
    let storeName: String
    let storeType: Int
    let curDist: Double
    let totalRating: Double
}
