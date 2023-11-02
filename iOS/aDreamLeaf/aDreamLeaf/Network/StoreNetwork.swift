//
//  StoreNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift
import Alamofire

class StoreNetwork: Network {
    
    init() {
        super.init(type: .Store)
    }
    
    func searchStore(with keyword: String) -> Observable<RequestResult<[SimpleStore]>> {
        return Observable<RequestResult<[SimpleStore]>>.create { observer in
            
            // POST 로 보낼 정보
//            let params =  LocationManager.permitionCheck() && LocationManager.getLatitude() != nil && LocationManager.getLongitude() != nil ? ["curLat": LocationManager.getLatitude()!, "curLogt": LocationManager.getLongitude()! ] : [:]
            let params = ["curLat": LocationManager.getLatitude()!, "curLogt": LocationManager.getLongitude()! ]
            
            let request = self.makeRequest(url: "/restaurant/findByKeyword?keyword=\(keyword)", method: .POST, params: params)
            
            AF.request(request).responseData{ response in
                self.handleResponse(response: response, observer: observer)
            }
                
            return Disposables.create()
        }
    }
    
    func searchWithLocation(lat: Double, long: Double) -> Observable<RequestResult<[SimpleStore]>> {
        return Observable.create { observer in
                
            let params = ["curLat": LocationManager.getLatitude()!, "curLogt": LocationManager.getLongitude()!]
             
            let request = self.makeRequest(url: "/restaurant/findByCur", method: .POST, params: params)
            
            AF.request(request).responseData{ (response) in
                self.handleResponse(response: response, observer: observer)
            }
                
            return Disposables.create()
        }
    }
    
    func fetchStoreDetail(storeId: Int) -> Observable<RequestResult<Store>> {
        return Observable.create { observer in
            
            // POST 로 보낼 정보
//            let params =  LocationManager.permitionCheck() && LocationManager.getLatitude() != nil && LocationManager.getLongitude() != nil ? ["curLat": LocationManager.getLatitude()!, "curLogt": LocationManager.getLongitude()! ] : [:]
            let params = ["curLat": LocationManager.getLatitude()!, "curLogt": LocationManager.getLongitude()! ]
             
            let request = self.makeRequest(url: "/restaurant/\(storeId)", method: .POST, params: params)
            
            AF.request(request).responseData{ (response) in
                self.handleResponse(response: response, observer: observer)
             }
                
            return Disposables.create()
        }
    }
}
