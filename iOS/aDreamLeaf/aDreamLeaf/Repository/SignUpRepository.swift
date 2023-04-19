//
//  SignUpRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/17.
//

import Foundation
import RxSwift

struct SignUpRepository {
    let network = SignUpNetwork()
    
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        return network.signUpRequestFB(email: email, pwd: pwd)
    }
    
    func sendEmailValification(email: String, pwd: String) {
        network.sendEmailVerificationFB(email: email, pwd: pwd)
    }
    
    private func validateInput(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult>? {
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
