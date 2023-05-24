//
//  StoreDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import Foundation
import RxSwift
import RxRelay

struct StoreDetailViewModel {
    let disposeBag = DisposeBag()
    let reviews = BehaviorSubject<[Review]>(value: [])
    
    let detail = PublishSubject<Store?>()
    
    let fetchReviewRequest = BehaviorSubject(value: Void())
    let fetchReviewResult = PublishSubject<RequestResult<[Review]>>()
    
    init(_ storeRepo: StoreRepository = StoreRepository(), _ reviewRepo: ReviewRepository = ReviewRepository()) {
        storeRepo.fetchDetail(storeId: 1)
            .map { $0.data }
            .bind(to: detail)
            .disposed(by: disposeBag)
        
        
        fetchReviewRequest
            .flatMap{ reviewRepo.fetchRecent(storeId: 1) }
            .bind(to: fetchReviewResult)
            .disposed(by: disposeBag)
        
        fetchReviewResult
            .filter { $0.success }
            .map { $0.data! }
            .bind(to: reviews)
            .disposed(by: disposeBag)
        
    
    }
}
