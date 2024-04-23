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
    
    enum ProfileNetworkError: String, Error {
        case tokenError = "토큰을 가져오는 과정에서 에러가 발생했습니다."
        case loginError = "현재 로그인된 유저 정보가 없습니다."
    }
    
    
    init() {
        super.init(type: .Profile)
    }
    
    func deleteAccountFB() -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    observer.onNext(.failure(ProfileNetworkError.loginError))
                }
                
                observer.onNext(.success(()))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAccountServer() -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    observer.onNext(.failure(ProfileNetworkError.tokenError))
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
