//
//  BudgetRequest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/19.
//

import Foundation

class BudgetRequest:Codable {
    
    init(token: String, amount: Int) {
        self.firebaseToken = token
        self.amount = amount
    }
    
    let amount: Int
    let firebaseToken: String
    
    func toDict() -> [String: Any] {
        return ["firebaseToken": self.firebaseToken, "amount": amount]
    }
}
