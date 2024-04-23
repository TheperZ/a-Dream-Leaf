//
//  ReviewRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol ReviewRepository {
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>>
    func update(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>>
    func fetchRecent(storeId: Int) -> Observable<[Review]>
    func fetchReviews(storeId: Int) -> Observable<[Review]>
    func deleteReview(reviewId: Int) -> Observable<Result<Void, Error>>
}
