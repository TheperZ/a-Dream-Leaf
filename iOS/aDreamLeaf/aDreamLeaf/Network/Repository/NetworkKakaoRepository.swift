//
//  NetworkKakaoRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/06.
//

import Foundation
import RxSwift

struct NetworkKakaoRepository {
    private let network = KakaoNetwork()
    
    func getMyAddress() -> Observable<String> {
        if LocationManager.permitionCheck() {
            return network.getAddress(lat: LocationManager.getLatitude(), lon: LocationManager.getLongitude())
                .map { result in
                    
                    switch result {
                        case let .success(addressData):
                            if addressData.documents.count >= 1 {
                                return addressData.documents[0].address?.address_name ?? addressData.documents[0].road_address?.address_name ?? "위치를 찾을 수 없습니다."
                            } else {
                                return "주소 정보를 찾을 수 없습니다."
                            }
                        case .failure(let failure):
                            return "오류가 발생했습니다. 잠시 후 다시 시도해주세요."
                    }
                }
        } else {
            return Observable.just("위치 정보 제공 동의를 해주세요")
        }
    }
    
}
