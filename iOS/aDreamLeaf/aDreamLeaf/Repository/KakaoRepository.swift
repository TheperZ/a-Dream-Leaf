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
                if result.success { // 통신 성공
                    if let data = result.data, data.count > 0 {
                        if data[0].road_address != nil {
                            return data[0].road_address!.address_name
                        } else if data[0].address != nil {
                            return data[0].address!.address_name
                        } else {
                            return "주소를 찾을 수 없습니다!"
                        }
                    } else {
                        return "주소를 찾을 수 없습니다!"
                    }
                } else {
                    return result.msg!
                }
            }
    }
}
