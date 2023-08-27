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
    
    init() {
        super.init(type: .Review)
    }
    
    func createReview(storeId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<Void>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
    
    func fetchRecentReview(storeId: Int) -> Observable<RequestResult<[Review]>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<[Review]>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
    
    func fetchAllReviews(storeId: Int) -> Observable<RequestResult<[Review]>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<[Review]>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
    
    func deleteReview(reviewId: Int) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<Void>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
    
    func updateRequest(reviewId: Int, body: String, rating: Int, image: UIImage?) -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.getIDToken() { token, error in
                
                if error != nil {
                    print(error)
                    observer.onNext(RequestResult<Void>(success: false, msg: "토큰을 가져오는 과정에서 오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", data: nil))
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
