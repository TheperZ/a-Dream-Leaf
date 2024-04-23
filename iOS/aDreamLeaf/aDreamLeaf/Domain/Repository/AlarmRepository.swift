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
    func register() -> Observable<Result<Void, Error>>
    func deregister() -> Observable<Result<Void, Error>>
}
