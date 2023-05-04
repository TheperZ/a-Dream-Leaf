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
    
    static func config() {
        // 위치추적권한요청 when in foreground
        locationManager.requestWhenInUseAuthorization()
        // 베터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    static func getLatitude() {
        print(locationManager.location?.coordinate.latitude)
    }
    
    static func getLongitude() {
        print(locationManager.location?.coordinate.longitude)
    }
  
}
