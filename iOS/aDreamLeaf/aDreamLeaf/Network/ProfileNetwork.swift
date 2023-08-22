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

class ProfileNetwork: Network {
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
                 
                let params = ["firebaseToken" : token]
                let request = self.makeRequest(url: "/myPage/delete", method: .POST, params: params)
                
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
}
