//
//  SignUpRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol SignUpRepository {
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>>
    func sendEmailValification(email: String, pwd: String)
    func validateInput(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>>?
}

extension SignUpRepository {
    func validateInput(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>>? {
        if email == "" {
            return Observable.just(RequestResult(success: false, msg: "이메일을 입력해주세요."))
        } else if !email.contains("@") {
            return Observable.just(RequestResult(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        } else if pwd != pwdCheck {
            return Observable.just(RequestResult(success: false, msg: "비밀번호가 일치하지 않습니다."))
        }  else if pwd.count < 6 {
            return Observable.just(RequestResult(success: false, msg: "비밀번호는 최소 6자리 이상 입력해주세요."))
        } else {
            return nil
        }
    }
}
