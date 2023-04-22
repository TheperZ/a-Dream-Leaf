//
//  StartViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/22.
//

import Foundation
import RxSwift
import RxRelay

struct StartViewModel {
    private let disposeBag = DisposeBag()
    let loginCheckRequest = PublishRelay<Void>()
    let isLogInChecked = PublishSubject<LoginResult>()
    
    init(_ repo: LoginRepository = LoginRepository()) {
        loginCheckRequest
            .flatMap(repo.localLogIn)
            .bind(to: isLogInChecked)
            .disposed(by: disposeBag)
    }
}
