//
//  ReivewListViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewListViewModel {
    let disposeBag = DisposeBag()
    let storeData : Store
    
    let reviews = PublishSubject<[Review]>()
    
    init(storeData: Store, _ repo: ReviewRepository = ReviewRepository()) {
        self.storeData = storeData
        
        repo.fetchReviews(storeId: storeData.storeId)
            .map { $0.data != nil ? $0.data! : []}
            .bind(to: reviews)
            .disposed(by: disposeBag)
    }
}
