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
        let result: Driver<Result<Void, Error>>
    }
    
    
    init(storeId: Int, editData: Review? = nil, _ repo: ReviewRepository = NetworkReviewRepository()) {
        self.repository = repo
        self.storeId = storeId
        self.editData = editData
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let rating = BehaviorSubject<Int>(value: 5)
        input.rating.drive(rating).disposed(by: disposeBag)
        
        let body = BehaviorSubject<String>(value: "")
        input.body.drive(body).disposed(by: disposeBag)
        
        let image = BehaviorSubject<UIImage?>(value: nil)
        input.image.drive(image).disposed(by: disposeBag)
        
        if let editData = editData {
            rating.onNext(editData.rating)
            body.onNext(editData.body)
            if let reviewImage = editData.reviewImage { // 리뷰에 사진이 포함된 경우
                image.onNext(Image.base64ToImg(with: reviewImage))
            }
        }
        
        let result = input.trigger
            .asObservable()
            .withLatestFrom(Observable.combineLatest(rating, body, image))
            .do(onNext: { _ in loading.onNext(true)} )
            .flatMapLatest { rating, body, image in
                if editData == nil {
                    repository.create(storeId: storeId, body: body, rating: rating, image: image)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: .success(()))
                } else {
                    repository.update(reviewId: editData!.reviewId, body: body, rating: rating, image: image)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: .success(()))
                }
            }
            .asDriver(onErrorJustReturn: .success(()))
        
        
        return Output(isEdit: editData != nil, editData: editData, loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
