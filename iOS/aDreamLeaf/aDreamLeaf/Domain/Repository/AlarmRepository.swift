//
//  AlarmRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol AlarmRepository {
    func getState() -> Observable<Bool>
    func register() -> Observable<RequestResult<Void>>
    func deregister() -> Observable<RequestResult<Void>>
}
