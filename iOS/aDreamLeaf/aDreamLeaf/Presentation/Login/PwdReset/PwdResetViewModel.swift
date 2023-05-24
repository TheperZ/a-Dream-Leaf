//
//  PwdResetViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/16.
//

import Foundation
import RxRelay
import RxSwift

struct PwdResetViewModel {
    let disposeBag = DisposeBag()
    
    let loading = BehaviorSubject<Bool>(value: false)
    
    let email = PublishRelay<String>()
    let resetBtnTap = PublishRelay<Void>()
    let resetResult = PublishSubject<RequestResult<Void>>()
    
    init(_ repo: LoginRepository = LoginRepository()) {
        
        resetBtnTap
            .withLatestFrom(email)
            .flatMap(repo.sendPwdResetMail)
            .bind(to: resetResult)
            .disposed(by: disposeBag)
        
        //MARK: - Loading
        
        resetBtnTap
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        resetResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
}
