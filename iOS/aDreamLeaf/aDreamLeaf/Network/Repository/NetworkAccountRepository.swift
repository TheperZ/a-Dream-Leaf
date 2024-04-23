//
//  AccountRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/18.
//

import Foundation
import RxSwift
import FirebaseAuth

struct NetworkAccountRepository: AccountRepository {
    enum NetworkAccountRepositoryError: String, Error {
        case emptyName = "가게명을 입력해주세요."
        case emptyPrice = "가격을 입력해주세요"
    }
    
    private let network = AccountNetwork()
    
    func setBudget(to budget: Int) -> Observable<Result<Void, Error>> {
        return network.setAccountBudget(to: budget)
    }
    
    func createRequest(date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>> {
        
        if let inputValidationResult = inputValidation(date: date, storeName: storeName, body: body, price: price) {
            return inputValidationResult
        }
        
        return network.createExpenditure(date: date, storeName: storeName, body: body, price: price)
    }
    
    func updateRequest(accountId: Int, date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>> {
        
        if let inputValidationResult = inputValidation(date: date, storeName: storeName, body: body, price: price) {
            return inputValidationResult
        }
        
        return network.updateExpenditure(accountId: accountId,date: date, storeName: storeName, body: body, price: price)
    }
    
    func getExpenditureList(when: String) -> Observable<[Expenditure]> {
        return network.getExpenditureList(when: when)
            .map { result in
                switch result {
                    case let .success(expenditures):
                        return expenditures
                        
                    case .failure:
                        return []
                }
            }
    }
    
    func getAccountSummary(yearMonth: String) -> Observable<[Int]> {
        return network.getAccountSummary(yearMonth: yearMonth)
            .map { result in
                switch result {
                    case let .success(data):
                        return [ data.charge, data.balance ]
                        
                    case .failure:
                        return [0, 0]
                }
            }
    }
    
    func deleteExpenditure(accountId: Int) -> Observable<Result<Void, Error>> {
        return network.deleteExpenditure(accountId: accountId)
    }
    
    private func inputValidation(date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>>? {
        if storeName == "" {
            return Observable.just(.failure(NetworkAccountRepositoryError.emptyName))
        } else if price < 0 {
            return Observable.just(.failure(NetworkAccountRepositoryError.emptyPrice))
        } else {
            return nil
        }
    }
}
