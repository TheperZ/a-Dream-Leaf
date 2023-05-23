//
//  ExpenditureListResult.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/20.
//

import Foundation

struct ExpenditureListResult {
    let success: Bool
    let msg: String?
    let list: [Expenditure]?
}
