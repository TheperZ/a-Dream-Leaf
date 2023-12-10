//
//  ReviewViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import Foundation
import RxSwift
import RxCocoa

struct ReviewViewModel {
    private let repository: ReviewRepository
    private let disposeBag = DisposeBag()
    private let storeId: Int
    private let editData: Review?
    
    struct Input {
        let trigger: Driver<Void>
        let rating: Driver<Int>
        let body: Driver<String>
        let image: Driver<UIImage?>
    }
    
    struct Output {
        let isEdit: Bool
        let editData: Review?
        let loading: Driver<Bool>
        let result: Driver<RequestResult<Void>>
    }
    
    
    init(storeId: Int, editData: Review? = nil, _ repo: ReviewRepository = NetworkReviewRepository()) {
        self.repository = repo
        self.storeId = storeId
        self.editData = editData
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.trigger
            .withLatestFrom(Driver.combineLatest(input.rating, input.body, input.image))
            .do(onNext: { _ in loading.onNext(true)} )
            .flatMapLatest { rating, body, image in
                if editData == nil {
                    repository.create(storeId: storeId, body: body, rating: rating, image: image)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
                } else {
                    repository.update(reviewId: editData!.reviewId, body: body, rating: rating, image: image)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: RequestResult(success: false, msg: nil))
                }
            }
        
        return Output(isEdit: editData != nil, editData: editData, loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
