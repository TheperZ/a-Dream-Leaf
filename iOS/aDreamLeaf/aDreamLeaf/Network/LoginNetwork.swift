//
//  LoginNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/18.
//

import Foundation
import RxSwift
import FirebaseAuth

struct LoginNetwork {
    func loginRequestFB(email: String, pwd: String) -> Observable<RequestResult> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if let error = error {
                    if error.localizedDescription == "The password is invalid or the user does not have a password." {
                        observer.onNext(RequestResult(success: false, msg: "비밀번호를 잘못 입력했습니다."))
                    } else if error.localizedDescription == "The email address is badly formatted." {
                        observer.onNext(RequestResult(success: false, msg: "이메일 형식이 잘못되었습니다."))
                    } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        observer.onNext(RequestResult(success: false, msg: "등록되지 않은 사용자입니다."))
                    } else {
                        observer.onNext(RequestResult(success: false, msg: error.localizedDescription))
                    }
                    
                }
                
                if let authResult = authResult {
                    if authResult.user.isEmailVerified {
                        observer.onNext(RequestResult(success: true, msg: nil))
                    } else {
                        observer.onNext(RequestResult(success: false, msg: "이메일 인증 후 로그인 해주세요"))
                    }
                    
                }
                
            }
            return Disposables.create()
        }
    }
}
