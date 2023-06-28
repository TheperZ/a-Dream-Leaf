//
//  ReviewRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift

struct ReviewRepository {
    private let network = ReviewNetwork()
    
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>> {
        
        if let validationResult = createInputValidate(body: body), validationResult != nil {
            return Observable.just(validationResult)
        }
        
        return network.createRequest(storeId: storeId, body: body, rating: rating, image: image)
    }
    
    func update(reviewId: Int, body: String, rating: Int) -> Observable<RequestResult<Void>> {
        
        if let validationResult = createInputValidate(body: body), validationResult != nil {
            return Observable.just(validationResult)
        }
        
        return network.updateRequest(reviewId: reviewId, body: body, rating: rating)
    }
    
    func fetchRecent(storeId: Int) -> Observable<RequestResult<[Review]>> {
        return network.fetchRecentRequest(storeId: storeId)
    }
    
    func fetchReviews(storeId: Int) -> Observable<RequestResult<[Review]>> {
        return network.fetchReviews(storeId: storeId)
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
