//
//  SignUpViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

struct SignUpViewModel {
    private let disposeBag = DisposeBag()
    private let repository: SignUpRepository
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let passwordCheck: Driver<String>
        let trigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let result: Driver<RequestResult<Void>>
    }
    
    init(_ repo: SignUpRepository = NetworkSignUpRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.trigger
            .withLatestFrom(Driver.combineLatest(input.email, input.password, input.passwordCheck))
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest { email, pwd, pwdCheck in
                repository.signUp(email: email, pwd: pwd, pwdCheck: pwdCheck)
                    .do(onNext: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
            }
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
