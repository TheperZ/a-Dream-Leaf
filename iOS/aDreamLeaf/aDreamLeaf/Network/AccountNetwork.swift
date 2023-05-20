//
//  AccountNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/18.
//

import Foundation
import RxSwift
import FirebaseAuth
import Alamofire

struct AccountNetwork {
    
    func setAccountBudget(to budget: Int) -> Observable<RequestResult> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
                
                print(token)
                
                let url = K.serverURL + "/account/setting"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = BudgetRequest(token: token, amount: budget).toDict()
                 
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
                                 print(response.response?.statusCode)
                                 observer.onNext(RequestResult(success: true, msg: nil))
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
    
    func createAccountServer(date: String, storeName: String, body: String, price: Int) -> Observable<RequestResult> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
                
                let url = K.serverURL + "/account/create"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = AccountRequest(token: token, restaurant: storeName, price: price, date: date, body: body).toDict()
                 
                 // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                }
                
                AF.request(request).responseJSON{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 print(response.response?.statusCode)
                                 
                                 observer.onNext(RequestResult(success: true, msg: nil))
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
    
    func getExpenditureList(when : String) -> Observable<ExpenditureListResult> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(ExpenditureListResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", list: nil))
                }
                
                guard let token = token else { return }
                
                let url = K.serverURL + "/account/list"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = ExpenditureListRequest(firebaseToken: token, yearMonth: when).toDict()
                 
                 // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                    observer.onNext(ExpenditureListResult(success: false, msg: "오류가 발생했습니다! \n잠시 후에 다시 시도해주세요!", list: nil))
                }
                
                AF.request(request).responseJSON{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 guard let result = response.data else {return}
                                 
                                 let decoder = JSONDecoder()
                                 let data = try decoder.decode([Expenditure].self, from: result)
                                 
                                 observer.onNext(ExpenditureListResult(success: true, msg: nil, list: data))
                             } catch(let err) {
                                 print(err)
                                 observer.onNext(ExpenditureListResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", list: nil))
                             }
                                 
                         case .failure(let error):
                                 print("error : \(error.errorDescription!)")
                                 observer.onNext(ExpenditureListResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", list: nil))
                     }
                 }
                
            }
            
            return Disposables.create()
        }
    }
}
