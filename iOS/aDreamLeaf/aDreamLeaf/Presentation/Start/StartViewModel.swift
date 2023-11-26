//
//  StartViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct StartViewModel {
    private let disposeBag = DisposeBag()
    private let repository: LoginRepository
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let result: Driver<Void>
    }
    
    init(_ repo: LoginRepository = LoginRepository()) {
        self.repository = repo
    }
    
    func tranform(input: Input) -> Output {
        let result = input.trigger
            .flatMapLatest {
                repository.localLogIn()
                    .map { _ in ()}
                    .asDriver(onErrorJustReturn: ())
            }
        
        return Output(result: result)
    }
}
