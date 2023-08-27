//
//  StoreDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import Foundation
import RxSwift
import RxRelay

struct StoreDetailViewModel: LoadingViewModel {
    var loading: PublishSubject<Bool>
    
    let disposeBag = DisposeBag()
    let reviews = BehaviorSubject<[Review]>(value: [])
    let storeId: Int
    
    let detail = PublishSubject<Store>()
    let fetchDetailResult = PublishSubject<RequestResult<Store>>()
    
    let fetchReviewRequest = BehaviorSubject(value: Void())
    let fetchReviewResult = PublishSubject<RequestResult<[Review]>>()
    
    init(storeId: Int, _ storeRepo: StoreRepository = StoreRepository(), _ reviewRepo: ReviewRepository = ReviewRepository()) {
        self.storeId = storeId
        
        loading = PublishSubject<Bool>()
        
        //가게 정보
        storeRepo.fetchDetail(storeId: storeId)
            .bind(to: fetchDetailResult)
            .disposed(by: disposeBag)
        
        fetchDetailResult
            .filter { $0.success }
            .map { $0.data! }
            .bind(to: detail)
            .disposed(by: disposeBag)
        
        //최근 리뷰 목록 업데이트 요청 시 불러오기
        fetchReviewRequest
            .flatMap{ reviewRepo.fetchRecent(storeId: storeId) }
            .bind(to: fetchReviewResult)
            .disposed(by: disposeBag)
        
        //최근 리뷰 목록 가져오기 결과에서 리뷰 목록 저장
        fetchReviewResult
            .filter { $0.success }
            .map { $0.data! }
            .bind(to: reviews)
            .disposed(by: disposeBag)
    
        //최근 리뷰 목록 요청 시 로딩 시작
        fetchReviewRequest
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)

        //최근 리뷰 목록 응답 시 로딩 종료
        fetchReviewResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
}
