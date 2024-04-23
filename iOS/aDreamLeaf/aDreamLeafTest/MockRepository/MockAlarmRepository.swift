//
//  MockAlarmRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/6/23.
//

@testable import aDreamLeaf
import Foundation
import RxSwift

struct MockAlarmRepository: AlarmRepository {

    func getState() -> RxSwift.Observable<Bool> {
        return Observable.just(true)
    }
    
    func register() -> Observable<Result<Void, Error>> {
        return .just(.success(()))
    }
    
    func deregister() -> Observable<Result<Void, Error>> {
        return .just(.success(()))
    }
    
    
}
