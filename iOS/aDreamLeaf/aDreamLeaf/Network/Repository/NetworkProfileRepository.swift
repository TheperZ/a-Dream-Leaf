//
//  ProfileRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/25.
//

import Foundation
import RxSwift

struct NetworkProfileRepository: ProfileRepository {
    private let network = ProfileNetwork()
    
    func deleteAccount() -> Observable<Result<Void, Error>> {
        
        //Server -> FB 순으로 삭제 요청 : Firebase Uid가 필요하기 때문...
        return network.deleteAccountServer() // 서버측에 정보 삭제 요청
            .flatMap { result in
                switch result {
                    case .success:
                        return network.deleteAccountFB()
                            .map { result in
                                
                                switch result {
                                    case .success:
                                        UserManager.logout() // Firebase 계정 삭제 성공시 로그아웃 처리
                                    case .failure(let failure):
                                        break
                                        
                                }
                                return result
                                
                            }
                    case let .failure(error):
                        return Observable.just(result)
                }
                
            }
    }
}
