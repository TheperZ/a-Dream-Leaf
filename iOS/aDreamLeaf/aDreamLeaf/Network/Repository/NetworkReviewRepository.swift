//
//  ReviewRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift

struct NetworkReviewRepository: ReviewRepository {
    private let network = ReviewNetwork()
    
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>> {
        
        if let validationResult = createInputValidate(body: body) {
            return Observable.just(validationResult)
        }
        
        return network.createReview(storeId: storeId, body: body, rating: rating, image: image)
    }
    
    func update(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>> {
        
        if let validationResult = createInputValidate(body: body) {
            return Observable.just(validationResult)
        }
        
        return network.updateRequest(reviewId: reviewId, body: body, rating: rating, image: image)
    }
    
    func fetchRecent(storeId: Int) -> Observable<[Review]> {
        return network.fetchRecentReview(storeId: storeId)
            .map { $0.data ?? []}
    }
    
    func fetchReviews(storeId: Int) -> Observable<[Review]> {
        return network.fetchAllReviews(storeId: storeId)
            .map { $0.data ?? [] }
    }
    
    func deleteReview(reviewId: Int) -> Observable<RequestResult<Void>> {
        return network.deleteReview(reviewId: reviewId)
    }
    
    private func createInputValidate(body: String) -> RequestResult<Void>? {
        if body.count < 10 {
            return RequestResult(success: false, msg: "최소 10글자 이상 입력해주세요.")
        }
        
        return nil
    }
    
}
