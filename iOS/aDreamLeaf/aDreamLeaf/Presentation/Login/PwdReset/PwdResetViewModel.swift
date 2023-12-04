//
//  PwdResetViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/16.
//

import Foundation
import RxSwift
import RxCocoa

struct PwdResetViewModel {
    private let disposeBag = DisposeBag()
    private let repository: LoginRepository
    
    struct Input {
        let email: Driver<String>
        let trigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let result: Driver<RequestResult<Void>>
    }
    
    init(_ repo: LoginRepository = NetworkLoginRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.trigger
            .withLatestFrom(input.email)
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest { email in
                repository.sendPwdResetMail(to: email)
                    .do(onNext: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
            }
        
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
