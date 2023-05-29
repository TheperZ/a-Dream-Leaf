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
    
    static func stringToDate(str: String) -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: str) {
            return date
        } else {
            return nil
        }
    }
}
