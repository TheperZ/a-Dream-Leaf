//
//  AlarmRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/28.
//

import Foundation
import RxSwift

struct AlarmRepository {
    private let network = AlarmNetwork(type: .Alarm)
    
    func getState() -> Observable<RequestResult<AlarmState>> {
        return network.checkState()
    }
    
    func register() -> Observable<RequestResult<Void>> {
        return network.register()
    }
    
    func deregister() -> Observable<RequestResult<Void>> {
        return network.deregister()
    }
}
