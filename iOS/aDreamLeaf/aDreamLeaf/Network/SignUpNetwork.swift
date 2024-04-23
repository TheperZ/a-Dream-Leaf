//
//  SignUpNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/17.
//

import Foundation
import RxSwift
import FirebaseAuth
import Alamofire

class SignUpNetwork: Network {
    
    enum SignUpNetworkError: String, Error {
        case loginError = "회원가입 전 로그인 과정에서 에러가 발생했습니다."
        case already = "이미 가입된 이메일입니다."
        case unknownError = "알 수 없는 에러가 발생했습니다."
        case authError = "인증 데이터를 가져오는 과정에서 에러가 발생했습니다."
        case tokenError = "토큰을 가져오는 과정에서 에러가 발생했습니다."
    }
    
    init() {
        super.init(type: .SignUp)
    }
    
    func signUpRequestFB(email: String, pwd: String) -> Observable<Result<Void, Error>> {
        
        return Observable.create { observer in
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://adreamleaf.firebaseapp.com/?email=\(email)")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

            Auth.auth().createUser(withEmail: email, password: pwd){ authData, error in
                if let error = error {
                    if error.localizedDescription == "The email address is already in use by another account." {
                        observer.onNext(.failure(SignUpNetworkError.already))
                    } else {
                        print(error.localizedDescription)
                        observer.onNext(.failure(SignUpNetworkError.unknownError))
                    }
                    
                } else {
                    observer.onNext(.success(()))
                }
            }
            
            return Disposables.create()
        }

        
    }
    
    func signUpRequestServer(email: String, pwd: String) -> Observable<Result<Void, Error>> {

        return Observable.create { observer in

            Auth.auth().signIn(withEmail: email, password: pwd) { authData, error in
                
                if error != nil {
                    observer.onNext(.failure(SignUpNetworkError.loginError))
                }
                
                guard let authData = authData else {
                    observer.onNext(.failure(SignUpNetworkError.authError))
                    return
                }
                
                authData.user.getIDToken() { token, error2 in
                    if error != nil {
                        observer.onNext(.failure(SignUpNetworkError.tokenError))
                    } else {
                        // POST 로 보낼 정보
                        let params = ["firebaseToken": token!, "email": authData.user.email!] as Dictionary
                        let request = self.makeRequest(url: "/login/signUp", method: .POST, params: params)
                        AF.request(request).responseData { (response) in
                            self.handleResponse(response: response, observer: observer)
                        }
                
                    }
                }
                
            }
            
            return Disposables.create()
        }

        
    }
    
    func sendEmailVerificationFB(email: String, pwd: String) {
        Auth.auth().signIn(withEmail: email, password: pwd) { authData, error in
            if error != nil {
                return
            }
            
            Auth.auth().currentUser?.sendEmailVerification()
        }
    }
}
