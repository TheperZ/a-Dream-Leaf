//
//  AlarmNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/28.
//

import Foundation
import Alamofire
import FirebaseAuth
import RxSwift
import FirebaseMessaging

class AlarmNetwork: Network {
    
    enum AlarmNetworkError: String, Error {
        case tokenError = "토큰을 가져오는 과정에서 에러가 발생했습니다."
    }
    
    init() {
        super.init(type: .Alarm)
    }
    
    func checkState() -> Observable<Result<AlarmState, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(AlarmNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token]
                
                let request = self.makeRequest(url: "/alarm", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func register() -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(AlarmNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token, "FCMToken": UserManager.FCMToken ?? "" ]
              
                let request = self.makeRequest(url: "/alarm/add", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func deregister() -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(AlarmNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token, "FCMToken": UserManager.FCMToken ?? "" ]
                
                let request = self.makeRequest(url: "/alarm/delete", method: .POST, params: params)
                 
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
}
