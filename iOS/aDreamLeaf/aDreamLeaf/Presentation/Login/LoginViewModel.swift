//
//  LoginViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    private let repository: LoginRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Driver<Void>
        let email: Driver<String>
        let pwd: Driver<String>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let result: Driver<Result<Void, Error>>
    }
    
    
    init(_ repo: LoginRepository = NetworkLoginRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        
        let result = input.trigger
            .withLatestFrom(Driver.combineLatest(input.email, input.pwd))
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest { email, pwd in
                repository.login(email: email, pwd: pwd)
                    .do(onNext: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: .success(()))
            }
            
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
