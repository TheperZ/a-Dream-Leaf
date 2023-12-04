//
//  LoginRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func login(email: String, pwd: String) -> Observable<RequestResult<User>>
    func localLogIn() -> Observable<RequestResult<User>>
    func sendPwdResetMail(to email: String) -> Observable<RequestResult<Void>>
    func logout() -> Observable<RequestResult<Void>>
}
