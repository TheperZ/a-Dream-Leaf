//
//  AccountViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import Foundation
import RxSwift
import RxCocoa

struct AccountViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AccountRepository
    struct Input {
        let trigger: Driver<Date>
        let select: Driver<IndexPath>
    }
    
    struct Output {
        let login: Driver<Bool>
        let expenditures: Driver<[Expenditure]>
        let selectedExpenditure: Driver<Expenditure>
    }
    
    init(_ repo: AccountRepository = AccountRepository()) {
        self.repository = repo
    }
    
    func tranform(input: Input) -> Output {
        let login = UserManager.getInstance().map { $0 != nil }.asDriver(onErrorJustReturn: false)
        
        let expenditures = input.trigger
            .map { Date.dateToString(with: $0, format: "yyyy-MM")}
            .flatMapLatest {
                repository.getExpenditureList(when: $0)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let selectedExpenditure = input.select
            .withLatestFrom(expenditures) { indexPath, list in list[indexPath.row] }
        
        return Output(login: login, expenditures: expenditures, selectedExpenditure: selectedExpenditure)
    }
}
