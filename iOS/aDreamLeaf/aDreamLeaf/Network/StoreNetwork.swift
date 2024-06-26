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
    
    func searchStore(with keyword: String) -> Observable<Result<[SimpleStore], Error>> {
        return Observable.create { observer in
            
            let params = ["curLat": LocationManager.getLatitude(), "curLogt": LocationManager.getLongitude() ]
            
            let request = self.makeRequest(url: "/restaurant/findByKeyword?keyword=\(keyword)", method: .POST, params: params)
            
            AF.request(request).responseData{ response in
                self.handleResponse(response: response, observer: observer)
            }
                
            return Disposables.create()
        }
    }
    
    func searchWithLocation(lat: Double, long: Double) -> Observable<Result<[SimpleStore], Error>> {
        return Observable.create { observer in
                
            let params = ["curLat": LocationManager.getLatitude(), "curLogt": LocationManager.getLongitude()]
             
            let request = self.makeRequest(url: "/restaurant/findByCur", method: .POST, params: params)
            
            AF.request(request).responseData{ (response) in
                self.handleResponse(response: response, observer: observer)
            }
                
            return Disposables.create()
        }
    }
    
    func fetchStoreDetail(storeId: Int) -> Observable<Result<Store, Error>> {
        return Observable.create { observer in
        
            let params = ["curLat": LocationManager.getLatitude(), "curLogt": LocationManager.getLongitude() ]
             
            let request = self.makeRequest(url: "/restaurant/\(storeId)", method: .POST, params: params)
            
            AF.request(request).responseData{ (response) in
                self.handleResponse(response: response, observer: observer)
             }
                
            return Disposables.create()
        }
    }
}
