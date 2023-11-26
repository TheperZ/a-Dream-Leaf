//
//  KakaoNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift
import Alamofire

class KakaoNetwork: Network{
    
    init() {
        super.init(type: .Kakao)
    }
    
    func getAddress(lat: Double, lon: Double) -> Observable<RequestResult<KakaoAddressResponse>> {
        return Observable.create { observer in
            
            let urlString = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(lon)&y=\(lat)"
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedString)!
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("KakaoAK \(Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as! String)", forHTTPHeaderField: "Authorization")

            AF.request(request).responseData { response in
                self.handleResponse<KakaoAddressResponse>(response: response, observer: observer)
            }
            
            return Disposables.create()
        }
    }
}
