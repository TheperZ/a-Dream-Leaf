//
//  ProfileNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/25.
//

import Foundation
import FirebaseAuth
import Alamofire
import RxSwift

struct ProfileNetwork {
    func deleteAccountFB() -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도 해주세요."))
                }
                
                observer.onNext(RequestResult(success: true, msg: nil))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAccountServer() -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
            
                let url = K.serverURL + "/myPage/delete"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                 
                let params = ["firebaseToken" : token]
                 // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                }
                
                AF.request(request).response{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 if let statusCode = response.response?.statusCode {
                                     switch statusCode {
                                         case 200..<300:
                                             observer.onNext(RequestResult(success: true, msg: nil))
                                         case 403, 404, 500:
                                             guard let result = response.data else { return }
                                             let decoder = JSONDecoder()
                                             let data = try decoder.decode(ErrorResponse.self, from: result)
                                             observer.onNext(RequestResult(success: false, msg: data.ErrorMessage))
                                         default:
                                             print("Account Error - Unknown status code: \(statusCode)")
                                             observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                     }
                                 }
                             } catch {
                                 observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                             }
                                 
                         case .failure(let error):
                                 print("error : \(error.errorDescription!)")
                                 observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                     }
                 }
                
            }
            
            return Disposables.create()
        }
    }
}
