//
//  KakaoRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift

struct KakaoRepositroy {
    private let network = KakaoNetwork()
    
    func getAddressKakao(lat: Double, lon: Double) -> Observable<String>{
        return network.getAddress(lat: lat, lon: lon)
            .map { result in
                if result != nil {
                    return result![0].road_address.address_name
                } else {
                    return "오류가 발생했습니다. 잠시후 시도해주세요."
                }
            }
    }
}
