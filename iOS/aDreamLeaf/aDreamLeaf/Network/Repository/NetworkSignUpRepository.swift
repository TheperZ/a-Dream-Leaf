//
//  NetworkSignUpRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/17.
//

import Foundation
import RxSwift
import FirebaseAuth

struct NetworkSignUpRepository: SignUpRepository {
    
    enum NetworkLoginRepositoryError: String, Error {
        case localLogin = "저장된 이메일과 비밀번호를 가져오는데에 실패했습니다."
        case logoutError = "로그아웃 과정에서 에러가 발생했습니다."
        case emptyEmail = "이메일을 입력해주세요."
        case emptyPassword = "비밀번호를 입력해주세요."
        case invalidEmailFormat = "올바르지 못한 이메일 형식입니다."
        case shortPassword = "비밀번호는 최소 6자리 이상 입력해주세요."
        case differentPassword = "비밀번호 확인이 일치하지 않습니다."
    }
    
    private let network = SignUpNetwork()
    private let disposeBag = DisposeBag()
    
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<Result<Void, Error>> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        let FBSignUpResult = network.signUpRequestFB(email: email, pwd: pwd)
        
        return FBSignUpResult
            .flatMap { result in
                
                switch result {
                    case .success:
                        let serverResult = network.signUpRequestServer(email: email, pwd: pwd)
                        
                        serverResult
                            .subscribe(onNext: { result in
                                
                                switch result {
                                    case .success:
                                        sendEmailValification(email: email, pwd: pwd)
                                    case .failure:
                                        Auth.auth().currentUser?.delete()
                                }
                            })
                            .disposed(by: disposeBag)
                        
                        return serverResult
                    case .failure:
                        return FBSignUpResult
                }
            }
    }
    
    func sendEmailValification(email: String, pwd: String) {
        network.sendEmailVerificationFB(email: email, pwd: pwd)
    }
    
    func validateInput(email: String, pwd: String, pwdCheck: String) -> RxSwift.Observable<Result<Void, any Error>>? {
        if email == "" {
            return Observable.just(.failure(NetworkLoginRepositoryError.emptyEmail))
        } else if !email.contains("@") || !email.contains(".") {
            return Observable.just(.failure(NetworkLoginRepositoryError.invalidEmailFormat))
        } else if pwd == "" {
            return Observable.just(.failure(NetworkLoginRepositoryError.emptyPassword))
        } else if pwd.count < 6 {
            return Observable.just(.failure(NetworkLoginRepositoryError.shortPassword))
        } else if pwd != pwdCheck {
            return Observable.just(.failure(NetworkLoginRepositoryError.differentPassword))
        } else {
            return nil
        }
    }
    

}
