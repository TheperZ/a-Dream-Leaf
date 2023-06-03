//
//  LoginNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/18.
//

import Foundation
import RxSwift
import FirebaseAuth
import Alamofire

struct LoginNetwork {
    func loginRequestFB(email: String, pwd: String) -> Observable<RequestResult<User>> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if let error = error {
                    if error.localizedDescription == "The password is invalid or the user does not have a password." {
                        observer.onNext(RequestResult<User>(success: false, msg: "비밀번호를 잘못 입력했습니다."))
                    } else if error.localizedDescription == "The email address is badly formatted." {
                        observer.onNext(RequestResult<User>(success: false, msg: "이메일 형식이 잘못되었습니다."))
                    } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        observer.onNext(RequestResult<User>(success: false, msg: "등록되지 않은 사용자입니다."))
                    } else {
                        observer.onNext(RequestResult<User>(success: false, msg: error.localizedDescription))
                    }
                    
                }
                
                if let authResult = authResult {
                    if authResult.user.isEmailVerified {
                        observer.onNext(RequestResult<User>(success: true, msg: nil, data: nil))
                    } else {
                        observer.onNext(RequestResult<User>(success: false, msg: "이메일 인증 후 로그인 해주세요"))
                    }
                    
                }
                
            }
            return Disposables.create()
        }
    }
    
    func loginRequestServer(email: String, pwd: String) -> Observable<RequestResult<User>> {
        return Observable.create { observer in

            Auth.auth().signIn(withEmail: email, password: pwd) { authData, error in
                
                if error != nil {
                    observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let authData = authData else {
                    observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                    return
                }
                
                authData.user.getIDToken() { token, error2 in
                    if error != nil {
                        observer.onNext(RequestResult<User>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                    } else {
                        let url = K.serverURL + "/login"
                         var request = URLRequest(url: URL(string: url)!)
                         request.httpMethod = "POST"
                         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                         request.timeoutInterval = 10
                         // POST 로 보낼 정보
                         let params = ["firebaseToken": token!] as Dictionary
                         
                         // httpBody 에 parameters 추가
                         do {
                             try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                         } catch {
                             print("http Body Error")
                             observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                         }
                        
                        AF.request(request).response{ (response) in
                             switch response.result {
                                 case .success:
                                     do {
                                         if let statusCode = response.response?.statusCode {
                                             guard let result = response.data else { return }
                                             let decoder = JSONDecoder()
                                             switch statusCode {
                                                 case 200: // 정상적으로 로그인 된 경우
                                                     let data = try decoder.decode(Login.self, from: result)
                                                     
                                                     UserManager.login(userData: User(email: data.email, password: pwd, nickname: data.userName))
                                                     observer.onNext(RequestResult<User>(success: true, msg: nil))
                                                     
                                                 default: // 어떠한 오류로 로그인에 실패한 경우
                                                     let data = try decoder.decode(ErrorResponse.self, from: result)
                                                     
                                                     print("Login Error: ", data.ErrorMessage) // 로그인 에러 원인 출력
                                                     observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                             }
                                             
                                         } else {
                                             
                                         }
                                         
                                     } catch {
                                         observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                     }
                                         
                                 case .failure(let error):
                                         print("error : \(error.errorDescription!)")
                                         observer.onNext(RequestResult<User>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                             }
                         }
                
                    }
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func sendPwdResetMailFB(_ email: String) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                   if error.localizedDescription == "The email address is badly formatted." {
                        observer.onNext(RequestResult(success: false, msg: "이메일 형식이 잘못되었습니다."))
                    } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        observer.onNext(RequestResult(success: false, msg: "등록되지 않은 사용자입니다."))
                    } else {
                        observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                    }
                    
                }
                
                observer.onNext(RequestResult(success: true, msg: nil))
            }
            
            return Disposables.create()
        }
    }
}
