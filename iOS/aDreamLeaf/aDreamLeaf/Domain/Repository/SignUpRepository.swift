//
//  SignUpRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol SignUpRepository {
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<Result<Void, Error>>
    func sendEmailValification(email: String, pwd: String)
    func validateInput(email: String, pwd: String, pwdCheck: String) -> Observable<Result<Void, Error>>?
}

