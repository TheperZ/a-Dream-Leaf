//
//  ExpenditureListRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/20.
//

import Foundation

class ExpenditureListRequest: Codable {
    
    init(firebaseToken: String, yearMonth: String) {
        self.firebaseToken = firebaseToken
        self.yearMonth = yearMonth
    }
    
    let firebaseToken: String
    let yearMonth: String
    
    func toDict() -> [String: Any] {
        return ["firebaseToken": firebaseToken, "yearMonth": yearMonth]
    }
}
