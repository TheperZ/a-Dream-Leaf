//
//  NetworkLoginRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/18.
//

import Foundation
import RxSwift
import FirebaseAuth

struct NetworkLoginRepository:LoginRepository {
    
    enum NetworkLoginRepositoryError: String, Error {
        case localLogin = "저장된 이메일과 비밀번호를 가져오는데에 실패했습니다."
        case logoutError = "로그아웃 과정에서 에러가 발생했습니다."
        case emptyEmail = "이메일을 입력해주세요."
        case emptyPassword = "비밀번호를 입력해주세요."
        case invalidEmailFormat = "올바르지 못한 이메일 형식입니다."
        case shortPassword = "비밀번호는 최소 6자리 이상 입력해주세요."
    }
    
    private let network = LoginNetwork(type: .Login)
    
    func login(email: String, pwd: String) -> Observable<Result<Void, Error>> {
        if let emailValidationResult = validateInput(email: email, pwd: pwd) {
            return emailValidationResult
        }
        
        let FBLoginResult = network.loginRequestFB(email: email, pwd: pwd)
        
        return FBLoginResult.flatMap { result in
            switch result {
                case .success:
                    return network.loginRequestServer(email: email, pwd: pwd)
                        .map { result in
                            switch result {
                                case let .success(data):
                                    UserManager.login(userData: data)
                                    return Result<(), Error>.success(())
                                    
                                case let .failure(error):
                                    return Result<(), Error>.failure(error)
                                
                            }
                            
                        }
                case .failure:
                    return FBLoginResult
            }
            
        }
    }
    
    func localLogIn() -> Observable<Result<Void, Error>> {
        if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
            return self.login(email: email, pwd: password)
        } else {
            return Observable.just(.failure(NetworkLoginRepositoryError.localLogin))
        }
        
    }
    
    func sendPwdResetMail(to email: String) -> Observable<Result<Void, Error>> {
        if let validationResult = validateEmail(email: email) {
            return validationResult
        }
        
        return network.sendPwdResetMailFB(email)
    }
    
    func logout() -> Observable<Result<Void, Error>> {
        do {
            try Auth.auth().signOut()
            UserManager.logout()
            return Observable.just(.success(()))
        } catch {
            return Observable.just(.failure(NetworkLoginRepositoryError.logoutError))
        }
    }
    
    private func validateInput(email: String, pwd: String) -> Observable<Result<Void, Error>>? {
        if email == "" {
            return Observable.just(.failure(NetworkLoginRepositoryError.emptyEmail))
        } else if pwd == "" {
            return Observable.just(.failure(NetworkLoginRepositoryError.emptyPassword))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(NetworkLoginRepositoryError.invalidEmailFormat))
        }  else if pwd.count < 6 {
            return Observable.just(.failure(NetworkLoginRepositoryError.shortPassword))
        } else {
            return nil
        }
    }
    
    private func validateEmail(email: String) -> Observable<Result<Void, Error>>? {
        if email == "" {
            return Observable.just(.failure(NetworkLoginRepositoryError.emptyEmail))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(NetworkLoginRepositoryError.invalidEmailFormat))
        } else {
            return nil
        }
    }
}
