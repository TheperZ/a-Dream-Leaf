//
//  LoginViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel: LoadingViewModel {
    var loading: PublishSubject<Bool>
    
    let disposeBag = DisposeBag()
    
    let email = PublishRelay<String>()
    let pwd = PublishRelay<String>()
    let loginBtnTap = PublishRelay<Void>()
    let loginResult = PublishSubject<RequestResult<User>>()
    
    init(_ repo: LoginRepository = LoginRepository()) {
        loading = PublishSubject<Bool>()
        
        loginBtnTap
            .withLatestFrom(Observable.combineLatest(email, pwd))
            .flatMap(repo.login)
            .bind(to: loginResult)
            .disposed(by: disposeBag)
        
        //MARK: - Loading
        
        loginBtnTap
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        loginResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        
    }
}
