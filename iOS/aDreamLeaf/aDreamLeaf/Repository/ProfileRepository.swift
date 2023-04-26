//
//  ProfileRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/25.
//

import Foundation
import RxSwift

struct ProfileRepository {
    private let network = ProfileNetwork()
    
    func deleteAccount() -> Observable<RequestResult> {
        return network.deleteAccountFB()
            .map { result in
                if result.success {
                    UserManager.logout()
                }
                return result
            }
    }
}
