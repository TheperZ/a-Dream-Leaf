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
    private let storeId: Int
    
    let editData : Review? // 리뷰 수정 시 리뷰 데이터, 신규 작성시 nil
    let rating = BehaviorSubject<Int>(value: 5)
    let body = BehaviorSubject<String>(value: "")
    
    let saveBtnTap = PublishSubject<Void>()
    
    let createRequestResult = PublishSubject<RequestResult<Void>>()
    
    init(storeId: Int, editData: Review?, _ repo: ReviewRepository = ReviewRepository()) {
        self.storeId = storeId
        self.editData = editData
        
        saveBtnTap
            .withLatestFrom(Observable.combineLatest(rating, body))
            .flatMap{rating, body in repo.create(storeId: storeId, body: body, rating: rating)}
            .bind(to: createRequestResult)
            .disposed(by: disposeBag)
    }
}
