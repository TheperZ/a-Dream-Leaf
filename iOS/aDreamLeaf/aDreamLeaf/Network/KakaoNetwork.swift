//
//  KakaoNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift
import Alamofire

class KakaoNetwork: Network {
    func getAddress(lat: Double, lon: Double) -> Observable<RequestResult<[KakaoAddress]>> {
        return Observable.create { observer in
            
            let urlString = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(lon)&y=\(lat)"
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            let request = self.makeRequest(url: encodedString,
                                           method: .POST,
                                           header: ["Authorization":"KakaoAK \(Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY"))"])
            
            
            if LocationManager.permitionCheck() == false {
                observer.onNext(RequestResult(success: false, msg: "위치 정보 제공을 동의해주세요"))
            } else {
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
            }
            
            return Disposables.create()
        }
    }
}


