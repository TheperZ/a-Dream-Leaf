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
    
    func register() -> RxSwift.Observable<aDreamLeaf.RequestResult<Void>> {
        return Observable.just(RequestResult(success: true, msg: "register"))
    }
    
    func deregister() -> RxSwift.Observable<aDreamLeaf.RequestResult<Void>> {
        return Observable.just(RequestResult(success: true, msg: "deregister"))
    }
    
    
}
