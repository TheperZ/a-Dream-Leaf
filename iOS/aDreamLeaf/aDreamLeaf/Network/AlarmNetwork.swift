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

struct AlarmNetwork {
    func checkState() -> Observable<RequestResult<Alarm>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
                
                let url = K.serverURL + "/alarm"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = ["firebaseToken": token]
                 
                 // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n잠시 후에 다시 시도해주세요!"))
                }
                
                AF.request(request).responseJSON{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 guard let result = response.data else { return }
                                 
                                 let decoder = JSONDecoder()
                                 let data = try decoder.decode(Alarm.self, from: result)
                                 
                                 print(data)
                                 
                                 observer.onNext(RequestResult(success: true, msg: nil, data: data))
                             } catch(let err) {
                                 print(err)
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
