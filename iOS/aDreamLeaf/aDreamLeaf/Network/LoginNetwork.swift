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

class LoginNetwork : Network {
    
    enum LoginNetworkError: String, Error {
        case wrongPassword = "비밀번호를 잘못 입력했습니다."
        case invalidEmailFormat = "이메일 형식이 잘못 되었습니다."
        case unknownUser = "등록되지 않은 사용자입니다."
        case unknownError = "알 수 없는 에러가 발생했습니다."
        case notAuthenticatedEamil = "이메일 인증 후 로그인 해주세요."
        case signInFBError = "FB 로그인 과정에서 에러가 발생했습니다."
        case invalidAuthData = "인증 데이터를 가져오는 과정에서 에러가 발생했습니다."
        case tokenError = "토큰을 가져오는 과정에서 에러가 발생했습니다."
        case decodingError = "디코딩 과정에서 에러가 발생했습니다."
    }
    
    func loginRequestFB(email: String, pwd: String) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if let error = error {
                    if error.localizedDescription == "The password is invalid or the user does not have a password." {
                        observer.onNext(.failure(LoginNetworkError.wrongPassword))
                    } else if error.localizedDescription == "The email address is badly formatted." {
                        observer.onNext(.failure(LoginNetworkError.invalidEmailFormat))
                    } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        observer.onNext(.failure(LoginNetworkError.unknownUser))
                    } else {
                        print(error.localizedDescription)
                        observer.onNext(.failure(LoginNetworkError.unknownError))
                    }
                    
                }
                
                if let authResult = authResult {
                    if authResult.user.isEmailVerified {
                        observer.onNext(.success(()))
                    } else {
                        observer.onNext(.failure(LoginNetworkError.notAuthenticatedEamil))
                    }
                    
                }
                
            }
            return Disposables.create()
        }
    }
    
    func loginRequestServer(email: String, pwd: String) -> Observable<Result<User, Error>> {
        return Observable.create { observer in

            Auth.auth().signIn(withEmail: email, password: pwd) { authData, error in
                
                if error != nil {
                    observer.onNext(.failure(LoginNetworkError.signInFBError))
                    return
                }
                
                guard let authData = authData else {
                    observer.onNext(.failure(LoginNetworkError.invalidAuthData))
                    return
                }
                
                authData.user.getIDToken() { token, error2 in
                    if error != nil {
                        observer.onNext(.failure(LoginNetworkError.tokenError))
                    } else {
                        let params = ["firebaseToken": token!] as Dictionary
                        let request = self.makeRequest(url: "/login", method: .POST, params: params)
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
                                                     let userData = User(userId: data.userId, email: data.email, nickname: data.userName, password: pwd)
                                                     UserManager.login(userData: userData)
                                                     observer.onNext(.success(userData))
                                                     
                                                 default: // 어떠한 오류로 로그인에 실패한 경우
                                                     let data = try decoder.decode(ErrorResponse.self, from: result)
                                                     
                                                     print("Login Error: ", data.ErrorMessage) // 로그인 에러 원인 출력
                                                     observer.onNext(.failure(NetworkError.invalidRequest))
                                             }
                                             
                                         }
                                         
                                     } catch {
                                         observer.onNext(.failure(NetworkError.decodingError))
                                     }
                                         
                                 case .failure(let error):
                                     print("error : \(error.errorDescription!)")
                                     observer.onNext(.failure(NetworkError.networkError))
                             }
                         }
                
                    }
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func sendPwdResetMailFB(_ email: String) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                   if error.localizedDescription == "The email address is badly formatted." {
                       observer.onNext(.failure(LoginNetworkError.invalidEmailFormat))
                    } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        observer.onNext(.failure(LoginNetworkError.unknownUser))
                    } else {
                        observer.onNext(.failure(LoginNetworkError.unknownError))
                    }
                    
                }
                
                observer.onNext(.success(()))
            }
            
            return Disposables.create()
        }
    }
}
