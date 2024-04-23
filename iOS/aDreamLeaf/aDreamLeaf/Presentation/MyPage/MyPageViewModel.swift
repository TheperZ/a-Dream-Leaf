//
//  MyPageViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

struct MyPageViewModel: LoadingViewModel {
    private let profileRepo: ProfileRepository
    private let loginRepo: LoginRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let logoutTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let email: Driver<String>
        let nickname: Driver<String>
        let logoutResult: Driver<Result<Void, Error>>
        let deleteResult: Driver<Result<Void, Error>>
    }
    
    var loading = PublishSubject<Bool>()

    
    init(_ profileRepo: ProfileRepository = NetworkProfileRepository(), _ loginRepo: LoginRepository = NetworkLoginRepository()) {
        self.profileRepo = profileRepo
        self.loginRepo = loginRepo
    }
    
    func tranform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let email = UserManager.getInstance().map { $0?.email ?? "" }.asDriver(onErrorJustReturn: "")
        let nickname = UserManager.getInstance().map { $0?.nickname ?? "" }.asDriver(onErrorJustReturn: "")
        
        let logoutResult = input.logoutTrigger
            .do(onNext: { loading.onNext(true) })
            .flatMapLatest {
                loginRepo.logout()
                    .do(onNext: { _ in loading.onNext(true) })
                    .asDriver(onErrorJustReturn: .success(()))
            }
        
        let deleteResult = input.deleteTrigger
            .do(onNext: { loading.onNext(true) })
            .flatMapLatest {
                profileRepo.deleteAccount()
                    .do(onNext: { _ in loading.onNext(true) })
                    .asDriver(onErrorJustReturn: .success(()))
            }
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), email: email, nickname: nickname, logoutResult: logoutResult, deleteResult: deleteResult)
    }
}
