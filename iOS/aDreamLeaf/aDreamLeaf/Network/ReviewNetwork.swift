//
//  ReviewNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseAuth

class ReviewNetwork: Network {
    
    enum ReviewNetworkError: String, Error {
        case tokenError = "토큰을 가져오는 과정에서 에러가 발생했습니다."
    }
    
    init() {
        super.init(type: .Review)
    }
    
    func createReview(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(ReviewNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                // POST 로 보낼 정보
                let params = CreateReviewRequest(firebaseToken: token, storeId: storeId, date: Date.now, body: body, rating: rating, image: image).toDict()
                
                let request = self.makeRequest(url: "/review/create", method: .POST, params: params)
                 
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func fetchRecentReview(storeId: Int) -> Observable<Result<[Review], Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(ReviewNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                
                let request = self.makeRequest(url: "/review/\(storeId)?page=1&display=3", method: .GET)
            
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func fetchAllReviews(storeId: Int) -> Observable<Result<[Review], Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(ReviewNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                let request = self.makeRequest(url: "/review/\(storeId)", method: .GET)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                 }
                
            }
            
            return Disposables.create()
        }
    }
    
    func deleteReview(reviewId: Int) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(ReviewNetworkError.tokenError))
                }
                
                guard let token = token else { return }

                // POST 로 보낼 정보
                let params = ["firebaseToken" : token, "reviewId": reviewId]
                
                let request = self.makeRequest(url: "/review/delete", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func updateRequest(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(.failure(ReviewNetworkError.tokenError))
                }
                
                guard let token = token else { return }
                
                let params = ["firebaseToken": token, "reviewId": reviewId, "date": Date.dateToString(with: Date.now), "body": body, "rating": rating, "reviewImage": Image.imgToBase64(with: image)]
                 
                let request = self.makeRequest(url: "/review/update", method: .POST, params: params)
                
                AF.request(request).responseData{ (response) in
                    self.handleResponse(response: response, observer: observer)
                }
                
            }
            
            return Disposables.create()
        }
    }
}
