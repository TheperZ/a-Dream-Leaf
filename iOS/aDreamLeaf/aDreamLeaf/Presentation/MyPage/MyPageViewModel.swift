//
//  MyPageViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxRelay

struct MyPageViewModel: LoadingViewModel {
    var disposeBag = DisposeBag()
    
    var loading = PublishSubject<Bool>()
    
    let email = UserManager.getInstance().map{ $0?.email ?? "" }
    let nickname = UserManager.getInstance().map{ $0?.nickname ?? "" }
    let deleteAccountBtnTap = PublishSubject<Void>()
    let deleteResult = PublishSubject<RequestResult<Void>>()
    
    init(_ repo: ProfileRepository = ProfileRepository()) {
        deleteAccountBtnTap
            .flatMapLatest(repo.deleteAccount)
            .bind(to: deleteResult)
            .disposed(by: disposeBag)
        
        //MARK: - Loading
        
        deleteAccountBtnTap
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        deleteResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
}
