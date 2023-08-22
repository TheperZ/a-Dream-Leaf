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

class AccountNetwork: Network {
    
    func deleteExpenditure(accountId: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
            
                // POST 로 보낼 정보
                let params = ExpenditureRequest(firebaseToken: token, accountId: accountId).toDict()
                 
                let request = self.makeRequest(url: "/account/delete", method: .POST, params: params)
                
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func setAccountBudget(to budget: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }

                // POST 로 보낼 정보
                let params = BudgetRequest(token: token, amount: budget).toDict()
                
                let request = self.makeRequest(url: "/account/setting", method: .POST, params: params)
                 
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func createExpenditure(date: String, storeName: String, body: String, price: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = AccountRequest(token: token, restaurant: storeName, price: price, date: date, body: body).toDict()
                 
                let request = self.makeRequest(url: "/account/create", method: .POST, params: params)
                
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func updateExpenditure(accountId: Int,date: String, storeName: String, body: String, price: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                var params =  AccountRequest(token: token, restaurant: storeName, price: price, date: date, body: body).toDict()
                params["accountId"] = accountId as Any
                
                let request = self.makeRequest(url: "/account/update", method: .POST, params: params)
                
                AF.request(request).responseData { (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func getExpenditureList(when : String) -> Observable<RequestResult<[Expenditure]>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }

                // POST 로 보낼 정보
                let params = ExpenditureListRequest(firebaseToken: token, yearMonth: when).toDict()
                
                let request = self.makeRequest(url: "/account/list", method: .POST, params: params)

                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func getAccountSummary(yearMonth: String) -> Observable<RequestResult<AccountSummary>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = AccountSummaryRequest(firebaseToken: token, yearMonth: yearMonth).toDict()
                
                let request = self.makeRequest(url: "/account", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
}
