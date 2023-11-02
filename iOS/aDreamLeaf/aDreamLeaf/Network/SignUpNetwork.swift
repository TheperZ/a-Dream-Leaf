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
    
    init() {
        super.init(type: .SignUp)
    }
    
    func signUpRequestFB(email: String, pwd: String) -> Observable<RequestResult<Void>> {
        
        return Observable.create { observer in
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://adreamleaf.firebaseapp.com/?email=\(email)")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

            Auth.auth().createUser(withEmail: email, password: pwd){ authData, error in
                if let error = error {
                    if error.localizedDescription == "The email address is already in use by another account." {
                        observer.onNext(RequestResult(success: false, msg: "이미 가입된 이메일입니다."))
                    } else {
                        observer.onNext(RequestResult(success: false, msg: "\(error.localizedDescription)"))
                    }
                    
                } else {
                    observer.onNext(RequestResult(success: true, msg: nil))
                }
            }
            
            return Disposables.create()
        }

        
    }
    
    func signUpRequestServer(email: String, pwd: String) -> Observable<RequestResult<Void>> {

        return Observable.create { observer in

            Auth.auth().signIn(withEmail: email, password: pwd) { authData, error in
                
                if error != nil {
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let authData = authData else {
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                    return
                }
                
                authData.user.getIDToken() { token, error2 in
                    if error != nil {
                        observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
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
