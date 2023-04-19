//
//  LoginRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/18.
//

import Foundation
import RxSwift

struct LoginRepository {
    private let network = LoginNetwork()
    func login(email: String, pwd: String) -> Observable<RequestResult> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        return network.loginRequestFB(email: email, pwd: pwd)
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<RequestResult>? {
        if email == "" {
            return Observable.just(RequestResult(success: false, msg: "이메일을 입력해주세요."))
        } else if pwd == "" {
            return Observable.just(RequestResult(success: false, msg: "비밀번호를 입력해주세요."))
        } else if !email.contains("@") {
            return Observable.just(RequestResult(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        }  else if pwd.count < 6 {
            return Observable.just(RequestResult(success: false, msg: "비밀번호는 최소 6자리 이상 입력해주세요."))
        } else {
            return nil
        }
    }
}
