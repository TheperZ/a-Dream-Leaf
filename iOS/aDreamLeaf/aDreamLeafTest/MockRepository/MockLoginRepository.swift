//
//  MockLoginRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/7/23.
//

@testable import aDreamLeaf
import RxSwift

struct MockLoginRepository: LoginRepository {
    func login(email: String, pwd: String) -> RxSwift.Observable<aDreamLeaf.RequestResult<aDreamLeaf.User>> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        
        return Observable.just(RequestResult(success: true, msg: "login", data: User(userId: 1, email: "asd@asd.com", nickname: "user", password: "asdfasdf")))
    }
    
    func localLogIn() -> RxSwift.Observable<aDreamLeaf.RequestResult<aDreamLeaf.User>> {
        return Observable.just(RequestResult(success: true, msg: "localLogIn", data: User(userId: 1, email: "asd@asd.com", nickname: "user", password: "asdfasdf")))
    }
    
    func sendPwdResetMail(to email: String) -> RxSwift.Observable<aDreamLeaf.RequestResult<Void>> {

        if let validationResult = validateEmail(email: email) {
            return validationResult
        }
        
        return Observable.just(RequestResult(success: true, msg: "mail"))
    }
    
    func logout() -> RxSwift.Observable<aDreamLeaf.RequestResult<Void>> {
        return Observable.just(RequestResult(success: true, msg: "logout"))
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<RequestResult<User>>? {
        if email == "" {
            return Observable.just(RequestResult<User>(success: false, msg: "이메일을 입력해주세요."))
        } else if pwd == "" {
            return Observable.just(RequestResult<User>(success: false, msg: "비밀번호를 입력해주세요."))
        } else if !email.contains("@") || !email.contains(".") {
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
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(RequestResult(success: false, msg: "올바르지 못한 이메일 형식입니다."))
        } else {
            return nil
        }
    }
    
}
