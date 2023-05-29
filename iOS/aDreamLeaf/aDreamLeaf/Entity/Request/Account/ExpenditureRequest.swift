//
//  ExpenditureRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/26.
//

import Foundation

class ExpenditureRequest: Codable {
    
    init(firebaseToken: String, accountId: Int) {
        self.firebaseToken = firebaseToken
        self.accountId = accountId
    }
    
    let firebaseToken: String
    let accountId: Int
    
    func toDict() -> [String: Any] {
        return ["firebaseToken": firebaseToken, "accountId": accountId]
    }
    
}
