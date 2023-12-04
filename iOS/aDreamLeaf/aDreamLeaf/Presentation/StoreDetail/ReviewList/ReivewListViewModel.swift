//
//  ReivewListViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxCocoa

struct ReviewListViewModel {
    private let repository: ReviewRepository
    private let disposeBag = DisposeBag()
    private let store: Store
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let deleteTrigger: Driver<Int>
    }
    
    struct Output {
        let storeName: Driver<String>
        let loading: Driver<Bool>
        let reviews: Driver<[Review]>
    }
    
    init(storeData: Store, _ repo: ReviewRepository = NetworkReviewRepository()) {
        self.repository = repo
        self.store = storeData
    }
    
    func transfrom(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let update = PublishSubject<Void>()
        
        let reviews = Driver.merge(input.viewWillAppear, update.asDriver(onErrorJustReturn: ()))
            .do(onNext: { loading.onNext(true) })
            .flatMapLatest {
                repository.fetchReviews(storeId: store.storeId)
                    .do(onNext: { _ in loading.onNext(false) })
                    .asDriver(onErrorJustReturn: [])
            }
        
        input.deleteTrigger
            .do(onNext: { _ in loading.onNext(true) })
            .flatMapLatest { reviewId in
                repository.deleteReview(reviewId: reviewId)
                    .do(onNext: { _ in loading.onNext(false) })
                    .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
            }
            .map { _ in () }
            .drive(update)
            .disposed(by: disposeBag)
        
        return Output(storeName: Driver.just(store.storeName),loading: loading.asDriver(onErrorJustReturn: false), reviews: reviews)
    }
}
