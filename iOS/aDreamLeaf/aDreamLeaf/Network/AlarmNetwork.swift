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
    func checkState() -> Observable<RequestResult<AlarmState>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<AlarmState>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token]
                
                let request = self.makeRequest(url: K.serverURL + "/alarm", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func register() -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token, "FCMToken": UserManager.FCMToken ?? "" ]
              
                let request = self.makeRequest(url: K.serverURL + "/alarm/add", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func deregister() -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = ["firebaseToken": token, "FCMToken": UserManager.FCMToken ?? "" ]
                
                let request = self.makeRequest(url: K.serverURL + "/alarm/delete", method: .POST, params: params)
                 
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
}
