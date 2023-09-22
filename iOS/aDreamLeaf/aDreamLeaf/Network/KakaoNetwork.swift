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
    func getAddress(lat: Double, lon: Double) -> Observable<[KakaoAddress]?> {
        return Observable.create { observer in
            
            let urlString = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(lon)&y=\(lat)"
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("KakaoAK \(Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as! String)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 10

            AF.request(request).response{ (response) in
                switch response.result {
                    case .success:
                        do {
                            if let statusCode = response.response?.statusCode {
                                switch statusCode {
                                    case 200..<300:
                                        let decodedData = try JSONDecoder().decode(KakaoAddressResponse.self, from: response.data!)
                                        observer.onNext(decodedData.documents)
                                    default:
                                        print("Kakao Network Error - Unknown status code: \(statusCode)")
                                        observer.onNext(nil)
                                }
                            }
                        } catch(let error) {
                            print(error)
                            observer.onNext(nil)
                        }
                        
                    case .failure(let error):
                        print("error : \(error.errorDescription!)")
                        observer.onNext(nil)
                }
            }
            
            return Disposables.create()
        }
    }
}
