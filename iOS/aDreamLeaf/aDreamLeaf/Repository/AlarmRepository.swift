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
    
    func getState() -> Observable<RequestResult<Alarm>> {
        return network.checkState()
    }
}
