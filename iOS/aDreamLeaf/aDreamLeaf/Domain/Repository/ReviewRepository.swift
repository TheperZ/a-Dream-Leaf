//
//  ReviewRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol ReviewRepository {
    func create(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>>
    func update(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>>
    func fetchRecent(storeId: Int) -> Observable<[Review]>
    func fetchReviews(storeId: Int) -> Observable<[Review]>
    func deleteReview(reviewId: Int) -> Observable<RequestResult<Void>>
}
