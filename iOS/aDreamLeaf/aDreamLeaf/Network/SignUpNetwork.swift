//
//  SignUpNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/17.
//

import Foundation
import RxSwift
import FirebaseAuth

struct SignUpNetwork {
    let disposeBag = DisposeBag()
    
    func signUpRequestFB(email: String, pwd: String) -> Observable<RequestResult> {
        
        return Observable.create { observer in
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://adreamleaf.firebaseapp.com/?email=\(email)")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

            Auth.auth().createUser(withEmail: email, password: pwd){ authData, error in
                if let error = error {
                    observer.onNext(RequestResult(success: false, msg: "\(error.localizedDescription)"))
                } else {
                    observer.onNext(RequestResult(success: true, msg: nil))
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
