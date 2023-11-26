//
//  AlarmRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/28.
//

import Foundation
import RxSwift

struct AlarmRepository {
    private let network = AlarmNetwork()
    
    func getState() -> Observable<Bool> {
        return network.checkState()
            .map { result in
                if result.success {
                    guard let state = result.data?.exist else { return false }
                    return state
                } else {
                    return false
                }
            }
    }
    
    func register() -> Observable<RequestResult<Void>> {
        return network.register()
    }
    
    func deregister() -> Observable<RequestResult<Void>> {
        return network.deregister()
    }
}
