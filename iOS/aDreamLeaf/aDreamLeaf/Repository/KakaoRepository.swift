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
    
    func getMyAddress() -> Observable<String> {
        if LocationManager.permitionCheck() {
            return network.getAddress(lat: LocationManager.getLatitude()!, lon: LocationManager.getLongitude()!).map(self.handleResult(_:))
        } else {
            return Observable.just("위치 정보 제공 동의를 해주세요")
        }
    }
    
    func handleResult(_ result: RequestResult<KakaoAddressResponse>) -> String {
        print(result.data!.documents)
        switch result.success {
            case true:
                if let addressData = result.data, addressData.documents.count >= 1 {
                    return addressData.documents[0].address?.address_name ?? addressData.documents[0].road_address?.address_name ?? "위치를 찾을 수 없습니다."
                } else {
                    return "주소 정보를 찾을 수 없습니다."
                }
                
            case false:
                return "오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
