//
//  MockAccountRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/4/23.
//

@testable import aDreamLeaf
import Foundation
import RxSwift

struct MockAccountRepository: AccountRepository {
    
    enum MockNetworkAccountRepositoryError: String, Error {
        case emptyName = "가게명을 입력해주세요."
        case emptyPrice = "가격을 입력해주세요"
    }
    
    let expenditureList = [
        Expenditure(userId: 1, accountId: 1, restaurant: "피자", price: 123, date: "2023-11", body: "점심"),
        Expenditure(userId: 2, accountId: 2, restaurant: "치킨", price: 123, date: "2023-12", body: "점심"),
        Expenditure(userId: 3, accountId: 3, restaurant: "돈까스", price: 123, date: "2023-10", body: "점심"),
        Expenditure(userId: 4, accountId: 4, restaurant: "카페", price: 123, date: "2023-12", body: "점심"),
    ]
    
    func setBudget(to budget: Int) -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    func createRequest(date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>> {
        
        if let inputValidationResult = inputValidation(date: date, storeName: storeName, body: body, price: price) {
            return inputValidationResult
        }
        
        print("\tcreateRequest")
        print("\tdate", date)
        print("\tstoreName", storeName)
        print("\tbody", body)
        
        return Observable.just(.success(()))
    }
    
    func updateRequest(accountId: Int, date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>> {
        
        print("\tupdateRequest")
        print("\taccountId", accountId)
        print("\tdate", date)
        print("\tstoreName", storeName)
        print("\tbody", body)
        
        
        if let inputValidationResult = inputValidation(date: date, storeName: storeName, body: body, price: price) {
            return inputValidationResult
        }
        
        return Observable.just(.success(()))
    }
    
    func getExpenditureList(when: String) -> Observable<[aDreamLeaf.Expenditure]> {
        return Observable.just(expenditureList.filter { $0.date == when})
    }
    
    func getAccountSummary(yearMonth: String) -> Observable<[Int]> {
        return Observable.just([100, 200])
    }
    
    func deleteExpenditure(accountId: Int) -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    private func inputValidation(date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>>? {
        if storeName == "" {
            return Observable.just(.failure(MockNetworkAccountRepositoryError.emptyName))
        } else if price < 0 {
            return Observable.just(.failure(MockNetworkAccountRepositoryError.emptyPrice))
        } else {
            return nil
        }
    }
    
}
