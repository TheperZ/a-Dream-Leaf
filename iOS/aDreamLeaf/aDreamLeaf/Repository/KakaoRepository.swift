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
                if result != nil, result!.count != 0 {
                    return result![0].address?.address_name ?? result![0].road_address?.address_name ?? "위치를 찾을 수 없습니다."
                } else {
                    return "오류가 발생했습니다. 잠시후 시도해주세요."
                }
            }
    }
}
