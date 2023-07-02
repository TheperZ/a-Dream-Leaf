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
    
    static func getNowKorDateString() -> String {
        
        /*
        // -----------------------------------------
        [getNowKorDate24 메소드 설명]
        // -----------------------------------------
        1. 한국 시간 대로 24 시간 설정을 맞춰서 날짜 및 시간 데이터 반환
        // -----------------------------------------
        2. 호출 방법 : C_Util().getNowKorDate24()
        // -----------------------------------------
        3. 리턴 반환 : 20220413155123
        // -----------------------------------------
        */
        
        // [초기 리턴 데이터 변수 선언 실시]
        var returnData = ""
        
        
        // [한국 날짜 및 시간 데이터 반환 실시]
        let date = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 24 시간 대 설정
        formatter.locale = Locale(identifier: "ko_kr") // 한국 시간 지정
        formatter.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대 지정
        
        // [리턴 변수에 삽입 실시]
        returnData = formatter.string(from: date) // string 형태
        
        // [리턴 데이터 반환 실시]
        return returnData
    }
    
    static func getNowKorDate() -> Date? {
        return stringToDate(str: getNowKorDateString())
    }

}
