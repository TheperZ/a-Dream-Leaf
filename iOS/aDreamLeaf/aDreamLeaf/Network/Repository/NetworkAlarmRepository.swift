//
//  AlarmRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/28.
//

import Foundation
import RxSwift

struct NetworkAlarmRepository: AlarmRepository {
    private let network = AlarmNetwork()
    
    func getState() -> Observable<Bool> {
        return network.checkState()
            .map { result in
                
                switch result {
                    case let .success(data):
                        return data.exist
                    case .failure(let failure):
                        return false
                }
            }
    }
    
    func register() -> Observable<Result<Void, Error>> {
        return network.register()
    }
    
    func deregister() -> Observable<Result<Void, Error>> {
        return network.deregister()
    }
}
