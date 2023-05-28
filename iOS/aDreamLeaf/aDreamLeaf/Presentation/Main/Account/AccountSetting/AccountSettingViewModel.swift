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
    
    
    let saveBtnTap = PublishRelay<Void>()
    
    let budgetSettingResult = PublishSubject<RequestResult<Void>>()
    
    
    init(_ accountRepo: AccountRepository = AccountRepository(), _ alarmRepo: AlarmRepository = AlarmRepository()) {
        saveBtnTap
            .withLatestFrom(amount)
            .flatMap(accountRepo.setBudget)
            .bind(to: budgetSettingResult)
            .disposed(by: disposeBag)
        
        alarmRepo.getState()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
