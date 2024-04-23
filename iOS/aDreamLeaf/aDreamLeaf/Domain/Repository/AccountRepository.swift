//
//  AccountRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol AccountRepository {
    func setBudget(to budget: Int) -> Observable<Result<Void, Error>>
    func createRequest(date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>>
    func updateRequest(accountId: Int, date: String, storeName: String, body: String, price: Int) -> Observable<Result<Void, Error>>
    func getExpenditureList(when: String) -> Observable<[Expenditure]>
    func getAccountSummary(yearMonth: String) -> Observable<[Int]>
    func deleteExpenditure(accountId: Int) -> Observable<Result<Void, Error>>
}
