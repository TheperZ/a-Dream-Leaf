//
//  String.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/09/10.
//

import Foundation

class StringUtil {
    static func getSimpleAddress(with address: String) -> String {
        var newAddress = address
        if address.contains("(") {
            newAddress = ""
            for s in Array(address).map({ String($0) }) {
                if s == "(" {
                    break
                }
                newAddress += s
            }
        }
        return newAddress
    }
    
    static func getRefinedDistance(with distance: Double) -> String {
        if distance >= 1 {
            return "\(String(format:"%.1f", distance))km"
        } else {
            return "\(Int(distance*1000))m"
        }
    }
}
