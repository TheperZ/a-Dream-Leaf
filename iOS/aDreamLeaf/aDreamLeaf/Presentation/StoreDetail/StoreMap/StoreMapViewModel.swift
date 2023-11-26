//
//  StoreMapViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/31.
//

import Foundation
import RxSwift
import RxRelay
import NMapsMap

struct StoreMapViewModel {
    private let disposeBag = DisposeBag()
    private let data: Store
    
    struct Input {
        
    }
    
    struct Output {
        let latitude: Double
        let longitude: Double
        let storeName: String
        let address: String
        let distance: Double
        let markers: [NMFMarker]
    }
    
    
    init(_ data: Store) {
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        
        let latitude = data.refineWGS84Lat
        let longitude = data.refineWGS84Logt
        let storeName = data.storeName
        let address = StringUtil.getSimpleAddress(with: data.refineRoadnmAddr)
        let distance = data.curDist
        
        let myPos = NMFMarker()
        let marker = NMFMarker()
        var markers = [NMFMarker]()
        
        if LocationManager.permitionCheck() {
            myPos.position = NMGLatLng(lat: LocationManager.getLatitude(), lng: LocationManager.getLongitude())
            myPos.width = 40
            myPos.height = 40
            myPos.iconImage = .init(image: UIImage(named: "myPosMarker")!)
            markers.append(myPos)
        }
    
        markers.append(marker)
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.width = 40
        marker.height = 40
        marker.iconImage = .init(image: UIImage(named: "storeMarker")!)
        
        return Output(latitude: latitude, longitude: longitude, storeName: storeName, address: address, distance: distance, markers: markers)
    }
}
