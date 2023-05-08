//
//  KakaoNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift
import RxAlamofire

struct KakaoNetwork {
    func getAddress(lat: Double, lon: Double) -> Observable<[KakaoAddress]?> {
        let urlString = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(lon)&y=\(lat)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        return RxAlamofire.requestData(.get, url, headers: ["Authorization": "KakaoAK \(Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as! String)"])
           .map { (r, data) in
               do {
                   let decodedData = try JSONDecoder().decode(KakaoAddressResponse.self, from: data)
                   return decodedData.documents
               } catch {
                   return nil
               }
           }
    }
}


class KakaoAddressResponse: Decodable {
    let documents: [KakaoAddress]
}

class KakaoAddress: Decodable {
    let road_address: KakaoAddressData
    let address: KakaoAddressData
}

class KakaoAddressData: Decodable {
    let address_name: String
}
