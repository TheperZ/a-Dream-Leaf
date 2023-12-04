//
//  UIChartViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift
import RxCocoa

struct UIChartViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AccountRepository
    
    struct Input {
        let trigger: Driver<Void>
        let date: Driver<Date>
    }
    
    struct Output {
        let data: Driver<[Int]>
        let login: Driver<Bool>
    }
    
    init(_ repo: AccountRepository = NetworkAccountRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let data = input.trigger
            .withLatestFrom(input.date)
            .flatMapLatest { date in
                repository.getAccountSummary(yearMonth: Date.dateToString(with: date, format: "yyyy-MM"))
                    .asDriver(onErrorJustReturn: [0,0])
            }
        
        let login = UserManager.getInstance().map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        return Output(data: data, login: login)
        
    }
    
}
