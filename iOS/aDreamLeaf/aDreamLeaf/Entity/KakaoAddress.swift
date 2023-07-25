//
//  KakaoAddress.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/07/04.
//

class KakaoAddressResponse: Decodable {
    let documents: [KakaoAddress]
}

class KakaoAddress: Decodable {
    let road_address: KakaoAddressData?
    let address: KakaoAddressData?
}

class KakaoAddressData: Decodable {
    let address_name: String
}

