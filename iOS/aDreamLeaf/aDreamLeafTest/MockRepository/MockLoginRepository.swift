//
//  MockLoginRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/7/23.
//

@testable import aDreamLeaf
import RxSwift

struct MockLoginRepository: LoginRepository {
    
    enum MockLoginRepositoryError: String, Error {
        case localLogin = "저장된 이메일과 비밀번호를 가져오는데에 실패했습니다."
        case logoutError = "로그아웃 과정에서 에러가 발생했습니다."
        case emptyEmail = "이메일을 입력해주세요."
        case emptyPassword = "비밀번호를 입력해주세요."
        case invalidEmailFormat = "올바르지 못한 이메일 형식입니다."
        case shortPassword = "비밀번호는 최소 6자리 이상 입력해주세요."
    }
    
    func login(email: String, pwd: String) -> Observable<Result<Void, Error>> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        
        return Observable.just(.success(()))
    }
    
    func localLogIn() -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    func sendPwdResetMail(to email: String) -> Observable<Result<Void, Error>> {

        if let validationResult = validateEmail(email: email) {
            return validationResult
        }
        
        return Observable.just(.success(()))
    }
    
    func logout() -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<Result<Void, Error>>? {
        if email == "" {
            return Observable.just(.failure(MockLoginRepositoryError.emptyEmail))
        } else if pwd == "" {
            return Observable.just(.failure(MockLoginRepositoryError.emptyPassword))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(MockLoginRepositoryError.invalidEmailFormat))
        }  else if pwd.count < 6 {
            return Observable.just(.failure(MockLoginRepositoryError.shortPassword))
        } else {
            return nil
        }
    }
    
    private func validateEmail(email: String) -> Observable<Result<Void, Error>>? {
        if email == "" {
            return Observable.just(.failure(MockLoginRepositoryError.emptyEmail))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(MockLoginRepositoryError.invalidEmailFormat))
        } else {
            return nil
        }
    }
    
}
