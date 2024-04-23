//
//  MockReviewRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/11/23.
//

@testable import aDreamLeaf
import RxSwift

struct MockReviewRepository: ReviewRepository {
    let reviews = [
        Review(userId: 1, userName: "name1", reviewId: 1, storeId: 1, storeName: "Store1", date: "2023-03-11", body: "좋아요!", rating: 3),
        Review(userId: 2, userName: "name2", reviewId: 2, storeId: 1, storeName: "Store1", date: "2023-05-11", body: "좋아요!", rating: 5),
        Review(userId: 3, userName: "name3", reviewId: 3, storeId: 1, storeName: "Store1", date: "2023-03-11", body: "좋아요!", rating: 3),
        Review(userId: 4, userName: "name4", reviewId: 4, storeId: 1, storeName: "Store1", date: "2023-03-11", body: "좋아요!", rating: 3),
        Review(userId: 5, userName: "name5", reviewId: 5, storeId: 5, storeName: "Store5", date: "2023-03-11", body: "좋아요!", rating: 3),
        Review(userId: 6, userName: "name6", reviewId: 6, storeId: 6, storeName: "Store6", date: "2023-03-11", body: "좋아요!", rating: 3),
    ]
    
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    func update(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    func fetchRecent(storeId: Int) -> RxSwift.Observable<[aDreamLeaf.Review]> {
        return Observable.just(Array(reviews.filter { $0.storeId == storeId}[0...3]))
    }
    
    func fetchReviews(storeId: Int) -> RxSwift.Observable<[aDreamLeaf.Review]> {
        return Observable.just(reviews.filter { $0.storeId == storeId })
    }
    
    func deleteReview(reviewId: Int) -> Observable<Result<Void, Error>> {
        return Observable.just(.success(()))
    }
    
    
}
