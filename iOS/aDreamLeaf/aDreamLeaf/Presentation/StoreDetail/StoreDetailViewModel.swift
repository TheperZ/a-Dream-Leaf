//
//  StoreDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import Foundation
import RxSwift
import RxCocoa

struct StoreDetailViewModel {
    private let disposeBag = DisposeBag()
    private let storeRepo: StoreRepository
    private let reviewRepo: ReviewRepository
    private let storeId: Int
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let login: Driver<Bool>
        let loading: Driver<Bool>
        let store: Driver<Store?>
        let reviews: Driver<[Review]>
    }
    
    init(storeId: Int, _ storeRepo: StoreRepository = StoreRepository(), _ reviewRepo: ReviewRepository = ReviewRepository()) {
        self.storeRepo = storeRepo
        self.reviewRepo = reviewRepo
        self.storeId = storeId
    }
    
    func transform(input: Input) -> Output {
        let login = UserManager.getInstance().map { $0 != nil }.asDriver(onErrorJustReturn: false)
        
        let storeLoading = PublishSubject<Bool>()
        let store = input.trigger
            .do(onNext: { storeLoading.onNext(true)})
            .flatMapLatest {
                storeRepo.fetchDetail(storeId: storeId)
                    .do(onNext: { _ in storeLoading.onNext(false)})
                    .asDriver(onErrorJustReturn: nil)
            }
        
        let reviewLoading = PublishSubject<Bool>()
        let reviews = input.trigger
            .do(onNext: { reviewLoading.onNext(true)})
            .flatMapLatest {
                reviewRepo.fetchRecent(storeId: storeId)
                    .do(onNext: { _ in reviewLoading.onNext(false)})
                    .asDriver(onErrorJustReturn: [])
            }
        
        let loading = Observable.combineLatest(storeLoading, reviewLoading)
            .map { $0 || $1 }
        
        return Output(login: login, loading: loading.asDriver(onErrorJustReturn: false), store: store, reviews: reviews)
    }
}
