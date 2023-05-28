//
//  AccountSettingViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxRelay

struct AccountSettingViewModel {
    private let disposeBag = DisposeBag()
    
    let amount = PublishSubject<Int>()
    
    let alarmState = PublishSubject<Bool>()
    
    let saveBtnTap = PublishRelay<Void>()
    let alarmSwitchChanged = PublishSubject<Bool>()
    
    let budgetSettingResult = PublishSubject<RequestResult<Void>>()
    let alarmStateResult = PublishSubject<RequestResult<AlarmState>>()
    let alarmRequestResult = PublishSubject<RequestResult<Void>>()
    
    init(_ accountRepo: AccountRepository = AccountRepository(), _ alarmRepo: AlarmRepository = AlarmRepository()) {
        saveBtnTap
            .withLatestFrom(amount)
            .flatMap(accountRepo.setBudget)
            .bind(to: budgetSettingResult)
            .disposed(by: disposeBag)
        
        alarmRepo.getState()
            .bind(to: alarmStateResult)
            .disposed(by: disposeBag)
        
        alarmStateResult
            .filter { $0.data != nil }
            .map { $0.data!.exist }
            .bind(to: alarmState)
            .disposed(by: disposeBag)
        
        alarmSwitchChanged
            .flatMap { isOn in
                print(isOn)
                if isOn {
                    return alarmRepo.register()
                } else {
                    return alarmRepo.deregister()
                }
            }
            .bind(to: alarmRequestResult)
            .disposed(by: disposeBag)
    }
}
