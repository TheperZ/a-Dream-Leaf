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
    private let network = SignUpNetwork()
    private let disposeBag = DisposeBag()
    
    func signUp(email: String, pwd: String, pwdCheck: String) -> Observable<RequestResult<Void>> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        let FBSignUpResult = network.signUpRequestFB(email: email, pwd: pwd)
        
        return FBSignUpResult
            .flatMap { result in
                if result.success {
                    let serverResult = network.signUpRequestServer(email: email, pwd: pwd)
                    
                    serverResult
                        .subscribe(onNext: { result in
                            if result.success {
                                sendEmailValification(email: email, pwd: pwd)
                            } else {
                                Auth.auth().currentUser?.delete()
                            }
                        })
                        .disposed(by: disposeBag)
                    
                    return serverResult
                } else {
                    return FBSignUpResult
                }
            }
    }
    
    func sendEmailValification(email: String, pwd: String) {
        network.sendEmailVerificationFB(email: email, pwd: pwd)
    }

}
