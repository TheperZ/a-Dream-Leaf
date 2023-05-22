//
//  ReviewViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewViewModel {
    private let disposeBag = DisposeBag()
    
    let rating = BehaviorSubject<Int>(value: 5)
    let body = BehaviorSubject<String>(value: "")
    
    let saveBtnTap = PublishSubject<Void>()
    
    let createRequestResult = PublishSubject<RequestResult>()
    
    init(_ repo: ReviewRepository = ReviewRepository()) {
        saveBtnTap
            .withLatestFrom(Observable.combineLatest(rating, body))
            .flatMap{rating, body in repo.create(storeId: 1, body: body, rating: rating)}
            .bind(to: createRequestResult)
            .disposed(by: disposeBag)
    }
}
