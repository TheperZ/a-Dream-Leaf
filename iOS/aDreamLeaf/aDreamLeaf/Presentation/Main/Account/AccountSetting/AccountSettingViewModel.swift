//
//  AccountSettingViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa

struct AccountSettingViewModel {
    private let disposeBag = DisposeBag()
    private let accountRepo: AccountRepository
    private let alarmRepo: AlarmRepository
    
    struct Input {
        let trigger: Driver<Void>
        let budget: Driver<Int>
        let budgetTrigger: Driver<Void>
        let alarmTrigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let alarm: Driver<Bool>
        let budgetResult: Driver<Result<Void, Error>>
    }
    
    init(_ accountRepo: AccountRepository = NetworkAccountRepository(), _ alarmRepo: AlarmRepository = NetworkAlarmRepository()) {
        self.accountRepo = accountRepo
        self.alarmRepo = alarmRepo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let budgetResult = input.budgetTrigger
            .withLatestFrom(input.budget)
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest {
                accountRepo.setBudget(to: $0)
                    .do(onNext: { _ in loading.onNext(false) })
                    .asDriver(onErrorJustReturn: .success(()))
            }
    
        
        let alarmUpdate = PublishSubject<Void>()
        let alarm = Driver.merge(alarmUpdate.asDriver(onErrorJustReturn: ()), input.trigger)
            .flatMapLatest {
                alarmRepo.getState()
                    .asDriver(onErrorJustReturn: false)
            }
        
        input.alarmTrigger
            .withLatestFrom(alarm)
            .do(onNext: { _ in loading.onNext(true) })
            .flatMapLatest { state in
                if state {
                    alarmRepo.deregister()
                        .asDriver(onErrorJustReturn: .success(()))
                } else {
                    alarmRepo.register()
                        .asDriver(onErrorJustReturn: .success(()))
                }
            }
            .map { _ in () }
            .do(onNext: { _ in loading.onNext(false) })
            .asObservable()
            .bind(to: alarmUpdate)
            .disposed(by: disposeBag)
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), alarm: alarm , budgetResult: budgetResult)
    }
}
