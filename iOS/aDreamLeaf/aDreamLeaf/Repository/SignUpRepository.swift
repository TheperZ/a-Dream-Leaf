//
//  SignUpRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/17.
//

import Foundation
import RxSwift

struct SignUpRepository {
    let network = SignUpNetwork(type: .SignUp)
    
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        let FBSignUpResult = network.signUpRequestFB(email: email, pwd: pwd)
        
        return FBSignUpResult
            .flatMap { result in
                if result.success {
                    return network.signUpRequestServer(email: email, pwd: pwd)
                } else {
                    return FBSignUpResult
                }
            }
    }
    
    func sendEmailValification(email: String, pwd: String) {
        network.sendEmailVerificationFB(email: email, pwd: pwd)
    }
    
    private func validateInput(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>>? {
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
