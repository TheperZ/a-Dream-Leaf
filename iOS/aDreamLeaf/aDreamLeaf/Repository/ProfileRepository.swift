//
//  ProfileRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/25.
//

import Foundation
import RxSwift

struct ProfileRepository {
    private let network = ProfileNetwork(type: .Profile)
    
    func deleteAccount() -> Observable<RequestResult<Void>> {
        
        //Server -> FB 순으로 삭제 요청 : Firebase Uid가 필요하기 때문...
        return network.deleteAccountServer() // 서버측에 정보 삭제 요청
            .flatMap { result in
                if result.success {// 서버측 정보 삭제 성공
                    return network.deleteAccountFB()
                        .map { result in
                            if result.success {// Firebase 계정 삭제에 성공
                                UserManager.logout() // Firebase 계정 삭제 성공시 로그아웃 처리
                            }
                            
                            return result
                        }
                } else { // 서버측에 정보 삭제 요청 실패
                    return Observable.just(result)
                }
            }
    }
}
