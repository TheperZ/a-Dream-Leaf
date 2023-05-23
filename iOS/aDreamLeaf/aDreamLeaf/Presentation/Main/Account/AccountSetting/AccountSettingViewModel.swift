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
    
    let budgetSettingResult = PublishSubject<RequestResult>()
    
    init(_ repo: AccountRepository = AccountRepository()) {
        saveBtnTap
            .withLatestFrom(amount)
            .flatMap(repo.setBudget)
            .bind(to: budgetSettingResult)
            .disposed(by: disposeBag)
    }
}
