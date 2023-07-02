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

struct SignUpNetwork {
    let disposeBag = DisposeBag()
    
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
                        let url = K.serverURL + "/login/signUp"
                        var request = URLRequest(url: URL(string: url)!)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.timeoutInterval = 10
                        // POST 로 보낼 정보
                        let params = ["firebaseToken": token!, "email": authData.user.email!] as Dictionary
                        
                        // httpBody 에 parameters 추가
                        do {
                            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                        } catch {
                            print("SignUp Error : http Body Error")
                            observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                        }
                        AF.request(request).response { (response) in
                            print(response.result)
                             switch response.result {
                                     
                                 case .success:
                                         do {
                                             if let status = response.response?.statusCode {
                                                 guard let result = response.data else {return}
                                                 
                                                 let decoder = JSONDecoder()
                                                 
                                                 switch(status){
                                                     case 201: // 회원가입 성공
                                                         observer.onNext(RequestResult(success: true, msg: nil))
                                                     case 400 : // Bad Request. 입력된 정보가 올바르지 않음
                                                         let data = try decoder.decode(ErrorResponse.self, from: result)
                                                         print("SignUp Error : \(data.ErrorMessage)")
                                                         observer.onNext(RequestResult(success: false, msg: "\(data.ErrorMessage)"))
                                                     case 503 : // Service Unavailable.
                                                         let data = try decoder.decode(ErrorResponse.self, from: result)
                                                         print("SignUp Error : Server Error - \(data.ErrorMessage)")
                                                         observer.onNext(RequestResult(success: false, msg: "\(data.ErrorMessage)"))
                                                     default: // 500 - ServerError ...
                                                         print("SignUp Error - error with response status : \(status)")
                                                         observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                                 }
                                             }
                                         } catch(let error) {
                                            print("SignUp Error - Decoding Error : ", error)
                                            observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                         }
                                 case .failure(let error):
                                         print("SignUp error - HTTP Error : \(error.errorDescription!)")
                                         observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                             }
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
