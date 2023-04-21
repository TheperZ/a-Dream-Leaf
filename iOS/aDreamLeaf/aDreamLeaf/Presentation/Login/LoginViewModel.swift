//
//  LoginViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import Foundation
import RxSwift
import RxRelay

struct LoginViewModel {
    let disposeBag = DisposeBag()
    let email = PublishRelay<String>()
    let pwd = PublishRelay<String>()
    let loginBtnTap = PublishRelay<Void>()
    let loginResult = PublishSubject<LoginResult>()
    
    init(_ repo: LoginRepository = LoginRepository()) {
        loginBtnTap
            .withLatestFrom(Observable.combineLatest(email, pwd))
            .flatMap(repo.login)
            .bind(to: loginResult)
            .disposed(by: disposeBag)
        
        /* 서버로부터 닉네임 가져오기 및 저장
        
         */
    }
}
