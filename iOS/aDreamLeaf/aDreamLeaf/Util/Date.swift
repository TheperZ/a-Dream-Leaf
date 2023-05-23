//
//  Date.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/19.
//

import Foundation

extension Date {
    static func dateToString(with date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
