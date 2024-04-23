//
//  LoginRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func login(email: String, pwd: String) -> Observable<Result<Void, Error>>
    func localLogIn() -> Observable<Result<Void, Error>>
    func sendPwdResetMail(to email: String) -> Observable<Result<Void, Error>>
    func logout() -> Observable<Result<Void, Error>>
}
