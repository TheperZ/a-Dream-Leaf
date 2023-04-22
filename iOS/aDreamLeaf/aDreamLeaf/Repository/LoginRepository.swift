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
    
    func login(email: String, pwd: String) -> Observable<LoginResult> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        return network.loginRequestFB(email: email, pwd: pwd)
    }
    
    func localLogIn() -> Observable<LoginResult> {
        if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
            return self.login(email: email, pwd: password)
        } else {
            return Observable.just(LoginResult(success: false))
        }
        
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<LoginResult>? {
        if email == "" {
            return Observable.just(LoginResult(success: false, msg: "이메일을 입력해주세요."))
        } else if pwd == "" {
            return Observable.just(LoginResult(success: false, msg: "비밀번호를 입력해주세요."))
        } else if !email.contains("@") {
            return Observable.just(LoginResult(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        }  else if pwd.count < 6 {
            return Observable.just(LoginResult(success: false, msg: "비밀번호는 최소 6자리 이상 입력해주세요."))
        } else {
            return nil
        }
    }
}
