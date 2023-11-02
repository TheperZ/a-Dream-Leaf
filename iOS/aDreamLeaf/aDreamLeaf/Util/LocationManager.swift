//
//  LocationManager.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/04.
//

import Foundation
import CoreLocation

struct LocationManager {
    private static let locationManager = CLLocationManager()
//    static func getTempLat() -> Double {
//        return 37.66
//    }
//    static func getTempLogt() -> Double {
//        return 126.7641867
//    }
    
    static func permitionCheck() -> Bool{
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .restricted, .notDetermined, .denied:
            return false
        default:
            return false
        }
    }
    static func config() {
        // 위치추적권한요청 when in foreground
        locationManager.requestWhenInUseAuthorization()
        // 베터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    static func getLatitude() -> Double? {
//        return locationManager.location?.coordinate.latitude
        return 37.6822
    }
    
    static func getLongitude() -> Double? {
//        return locationManager.location?.coordinate.longitude
        return 126.7695
    }
  
}
