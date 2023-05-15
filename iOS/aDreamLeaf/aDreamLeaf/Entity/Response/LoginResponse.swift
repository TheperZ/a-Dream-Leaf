//
//  LoginResponse.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/16.
//

import Foundation

class LoginResponse: Decodable {
    let userId: Int
    let email: String
    let userName: String
}
