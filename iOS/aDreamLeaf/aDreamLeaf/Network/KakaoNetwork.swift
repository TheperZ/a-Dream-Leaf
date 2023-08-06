//
//  KakaoNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift
import Alamofire

struct KakaoNetwork {
    func getAddress(lat: Double, lon: Double) -> Observable<RequestResult<[KakaoAddress]>> {
        return Observable.create { observer in
            
            let urlString = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(lon)&y=\(lat)"
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("KakaoAK \(Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as! String)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 10
            
            
            if LocationManager.permitionCheck() == false {
                observer.onNext(RequestResult(success: false, msg: "위치 정보 제공을 동의해주세요"))
            } else {
                AF.request(request).response{ (response) in
                    switch response.result {
                        case .success:
                            do {
                                if let statusCode = response.response?.statusCode {
                                    switch statusCode {
                                        case 200..<300:
                                            let decodedData = try JSONDecoder().decode(KakaoAddressResponse.self, from: response.data!)
                                            observer.onNext(RequestResult(success: true, msg: nil, data: decodedData.documents))
                                        default:
                                            print("Kakao Network Error - Unknown status code: \(statusCode)")
                                            observer.onNext(RequestResult(success: false, msg: "카카오 네트워크 오류"))
                                    }
                                }
                            } catch(let error) {
                                print(error)
                                observer.onNext(RequestResult(success: false, msg: "네트워크 오류 - \(error)"))
                            }
                            
                        case .failure(let error):
                            print("error : \(error.errorDescription!)")
                            observer.onNext(RequestResult(success: false, msg: "네트워크 오류 - \(error)"))
                    }
                }
            }
            
            
            
            return Disposables.create()
        }
    }
}


