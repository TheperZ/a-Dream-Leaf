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
    
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        
        if let validationResult = createInputValidate(body: body) {
            return Observable.just(validationResult)
        }
        
        return network.createReview(storeId: storeId, body: body, rating: rating, image: image)
    }
    
    func update(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        
        if let validationResult = createInputValidate(body: body) {
            return Observable.just(validationResult)
        }
        
        return network.updateRequest(reviewId: reviewId, body: body, rating: rating, image: image)
    }
    
    func fetchRecent(storeId: Int) -> Observable<[Review]> {
        return network.fetchRecentReview(storeId: storeId)
            .map { result in
                switch result {
                    case let .success(reviews):
                        return reviews
                        
                    case .failure:
                        return []
                }
            }
    }
    
    func fetchReviews(storeId: Int) -> Observable<[Review]> {
        return network.fetchAllReviews(storeId: storeId)
            .map { result in
                switch result {
                    case let .success(reviews):
                        return reviews
                        
                    case .failure:
                        return []
                }
            }
    }
    
    func deleteReview(reviewId: Int) -> Observable<Result<Void, Error>> {
        return network.deleteReview(reviewId: reviewId)
    }
    
    private func createInputValidate(body: String) -> Result<Void, Error>? {
        //TODO: 
//        if body.count < 10 {
//            return Error(success: false, msg: "최소 10글자 이상 입력해주세요.")
//        }
        
        return nil
    }
    
}
