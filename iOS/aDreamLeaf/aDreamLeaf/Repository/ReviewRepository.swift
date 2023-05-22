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
    
    func create(storeId: Int, body: String, rating: Int) -> Observable<RequestResult> {
        
        if let validationResult = createInputValidate(body: body), validationResult != nil {
            return Observable.just(validationResult)
        }
        
        return network.createRequest(storeId: storeId, body: body, rating: rating)
    }
    
    private func createInputValidate(body: String) -> RequestResult? {
        if body.count < 10 {
            return RequestResult(success: false, msg: "최소 10글자 이상 입력해주세요.")
        }
        
        return nil
    }
}
