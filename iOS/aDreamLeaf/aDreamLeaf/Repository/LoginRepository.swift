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
    
    func login(email: String, pwd: String) -> Observable<RequestResult<User>> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        
        let FBLoginResult = network.loginRequestFB(email: email, pwd: pwd)
        
        return FBLoginResult.flatMap { result in
            if result.success {
                return network.loginRequestServer(email: email, pwd: pwd)
            } else {
                return FBLoginResult
            }
        }
    }
    
    func localLogIn() -> Observable<RequestResult<User>> {
        if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
            return self.login(email: email, pwd: password)
        } else {
            return Observable.just(RequestResult<User>(success: false, msg: "오류가 발생했습니다.\n잠시 후에 다시 시도해주세요"))
        }
        
    }
    
    func sendPwdResetMail(to email: String) -> Observable<RequestResult<Void>> {
        if let validationResult = validateEmail(email: email) {
            return validationResult
        }
        
        return network.sendPwdResetMailFB(email)
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<RequestResult<User>>? {
        if email == "" {
            return Observable.just(RequestResult<User>(success: false, msg: "이메일을 입력해주세요."))
        } else if pwd == "" {
            return Observable.just(RequestResult<User>(success: false, msg: "비밀번호를 입력해주세요."))
        } else if !email.contains("@") {
            return Observable.just(RequestResult<User>(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        }  else if pwd.count < 6 {
            return Observable.just(RequestResult<User>(success: false, msg: "비밀번호는 최소 6자리 이상 입력해주세요."))
        } else {
            return nil
        }
    }
    
    private func validateEmail(email: String) -> Observable<RequestResult<Void>>? {
        if email == "" {
            return Observable.just(RequestResult(success: false, msg: "이메일을 입력해주세요."))
        } else if !email.contains("@") {
            return Observable.just(RequestResult(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        } else {
            return nil
        }
    }
}
