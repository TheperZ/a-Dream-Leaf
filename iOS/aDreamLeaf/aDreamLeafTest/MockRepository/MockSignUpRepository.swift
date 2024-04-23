//
//  MockSignUpRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/8/23.
//

@testable import aDreamLeaf
import Foundation
import RxSwift

struct MockSignUpRepository: SignUpRepository {
    
    enum MockLoginRepositoryError: String, Error {
        case localLogin = "저장된 이메일과 비밀번호를 가져오는데에 실패했습니다."
        case logoutError = "로그아웃 과정에서 에러가 발생했습니다."
        case emptyEmail = "이메일을 입력해주세요."
        case emptyPassword = "비밀번호를 입력해주세요."
        case invalidEmailFormat = "올바르지 못한 이메일 형식입니다."
        case shortPassword = "비밀번호는 최소 6자리 이상 입력해주세요."
        case differentPassword = "비밀번호 확인이 일치하지 않습니다."
    }
    
    func validateInput(email: String, pwd: String, pwdCheck: String) -> RxSwift.Observable<Result<Void, any Error>>? {
        if email == "" {
            return Observable.just(.failure(MockLoginRepositoryError.emptyEmail))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(MockLoginRepositoryError.invalidEmailFormat))
        } else if pwd == "" {
            return Observable.just(.failure(MockLoginRepositoryError.emptyPassword))
        } else if pwd.count < 6 {
            return Observable.just(.failure(MockLoginRepositoryError.shortPassword))
        } else if pwd != pwdCheck {
            return Observable.just(.failure(MockLoginRepositoryError.differentPassword))
        } else {
            return nil
        }
    }
    
    func signUp(email: String, pwd: String, pwdCheck: String) -> RxSwift.Observable<Result<Void, Error>> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        return Observable.just(.success(()))
    }
    
    func sendEmailValification(email: String, pwd: String) {
        print("\n\n Send Email \n\n")
        return
    }
    
    
}
