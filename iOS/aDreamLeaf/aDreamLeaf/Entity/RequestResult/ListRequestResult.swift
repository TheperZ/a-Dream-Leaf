//
//  ReviewRequestResult.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation

struct ListRequestResult<T> {
    let success: Bool
    let msg: String?
    let data: [T]?
}
