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
    
    func deleteExpenditure(accountId: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
            
                let url = K.serverURL + "/account/delete"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = ExpenditureRequest(firebaseToken: token, accountId: accountId).toDict()
                 
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
                                             observer.onNext(RequestResult(success: true, msg: "지출 내역이 삭제되었습니다."))
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
    
    func setAccountBudget(to budget: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }

                
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
                                 if let statusCode = response.response?.statusCode {
                                     switch statusCode {
                                         case 200:
                                             observer.onNext(RequestResult(success: true, msg: nil))
                                         case 400, 500:
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
    
    func createExpenditure(date: String, storeName: String, body: String, price: Int) -> Observable<RequestResult<Void>> {
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
                                 if let statusCode = response.response?.statusCode {
                                     switch statusCode {
                                         case 200..<300:
                                             observer.onNext(RequestResult(success: true, msg: "지출 내역이 추가되었습니다."))
                                         case 400, 500:
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
    
    func updateExpenditure(accountId: Int,date: String, storeName: String, body: String, price: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요."))
                }
                
                guard let token = token else { return }
                
                let url = K.serverURL + "/account/update"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                var params =  AccountRequest(token: token, restaurant: storeName, price: price, date: date, body: body).toDict()
                params["accountId"] = accountId as Any
                 
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
                                             observer.onNext(RequestResult(success: true, msg: "지출 내역이 수정되었습니다."))
                                         case 400, 403, 404, 500:
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
    
    func getExpenditureList(when : String) -> Observable<RequestResult<[Expenditure]>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<[Expenditure]>(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
                    observer.onNext(RequestResult<[Expenditure]>(success: false, msg: "오류가 발생했습니다! \n잠시 후에 다시 시도해주세요!", data: nil))
                }
                
                AF.request(request).responseJSON{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 if let statusCode = response.response?.statusCode {
                                     switch statusCode {
                                         case 200..<300:
                                             guard let result = response.data else {return}
                                             
                                             let decoder = JSONDecoder()
                                             let data = try decoder.decode([Expenditure].self, from: result)
                                             
                                             observer.onNext(RequestResult<[Expenditure]>(success: true, msg: nil, data: data))
                                         case 400, 500:
                                             guard let result = response.data else { return }
                                             let decoder = JSONDecoder()
                                             let data = try decoder.decode(ErrorResponse.self, from: result)
                                             observer.onNext(RequestResult(success: false, msg: data.ErrorMessage))
                                         default:
                                             print("Account Error - Unknown status code: \(statusCode)")
                                             observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                     }
                                 }
                                 
                             } catch(let err) {
                                 print(err)
                                 observer.onNext(RequestResult<[Expenditure]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                             }
                                 
                         case .failure(let error):
                                 print("error : \(error.errorDescription!)")
                                 observer.onNext(RequestResult<[Expenditure]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                     }
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
                    observer.onNext(RequestResult<AccountSummary>(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
                }
                
                guard let token = token else { return }
                
                let url = K.serverURL + "/account"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                // POST 로 보낼 정보
                let params = AccountSummaryRequest(firebaseToken: token, yearMonth: yearMonth).toDict()
                 
                 // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                    observer.onNext(RequestResult<AccountSummary>(success: false, msg: "오류가 발생했습니다! \n잠시 후에 다시 시도해주세요!", data: nil))
                }
                
                AF.request(request).responseJSON{ (response) in
                     switch response.result {
                         case .success:
                             do {
                                 if let statusCode = response.response?.statusCode {
                                     switch statusCode {
                                         case 200..<300:
                                             guard let result = response.data else {return}
                                             
                                             let decoder = JSONDecoder()
                                             let data = try decoder.decode(AccountSummary.self, from: result)
                                             
                                             observer.onNext(RequestResult<AccountSummary>(success: true, msg: nil, data: data))
                                         case 400, 500:
                                             guard let result = response.data else { return }
                                             let decoder = JSONDecoder()
                                             let data = try decoder.decode(ErrorResponse.self, from: result)
                                             observer.onNext(RequestResult(success: false, msg: data.ErrorMessage))
                                         default:
                                             print("Account Error - Unknown status code: \(statusCode)")
                                             observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!"))
                                     }
                                 }
                             } catch(let err) {
                                 print(err)
                                 observer.onNext(RequestResult<AccountSummary>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                             }
                                 
                         case .failure(let error):
                                 print("error : \(error.errorDescription!)")
                                 observer.onNext(RequestResult<AccountSummary>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                     }
                 }
                
            }
            
            return Disposables.create()
        }
    }
}
