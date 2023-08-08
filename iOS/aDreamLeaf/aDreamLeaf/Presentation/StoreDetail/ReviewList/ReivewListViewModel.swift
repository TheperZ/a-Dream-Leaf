//
//  ReivewListViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxRelay

class ReviewListViewModel: LoadingViewModel {
    let disposeBag = DisposeBag()
    let storeData : Store
    
    let reviews = PublishSubject<[Review]>()
    
    //ReviewCell로 부터 온 리뷰 삭제 처리 Observe - 리뷰 ID를 전달받음
    let reviewDeleteRequest = PublishSubject<Int>()
    //리뷰 삭제 결과
    let reviewDeleteResult = PublishSubject<RequestResult<Void>>()
    
    //리뷰 수정/삭제시 리스트 업데이트를 위한 Subject
    let reviewListUpdateRequest = PublishSubject<Void>()
    
    init(storeData: Store, _ repo: ReviewRepository = ReviewRepository()) {
        self.storeData = storeData
        
        super.init()
        
        // 리뷰 목록 업데이트 요청 시 로딩 시작
        reviewListUpdateRequest
            .map { return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        // 리뷰 목록이 업데이트 되면 로딩 종료
        reviews
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        
        //리뷰 목록 업데이트 요청 시 목록 가져오기
        reviewListUpdateRequest
            .flatMap { repo.fetchReviews(storeId: storeData.storeId)}
            .map { $0.data != nil ? $0.data! : []} // 에러 발생시 리뷰 빈 목록 
            .bind(to: reviews)
            .disposed(by: disposeBag)
        
        //초기 리뷰 목록 가져오기
        reviewListUpdateRequest.onNext(Void())
        
        //리뷰 삭제 요청 처리
        reviewDeleteRequest
            .flatMap(repo.deleteReview)
            .bind(to: reviewDeleteResult)
            .disposed(by: disposeBag)
        
        //리뷰 삭제 성공 시 리뷰 목록 업데이트
        reviewDeleteResult
            .filter { $0.success == true }
            .map { _ in Void() }
            .bind(to: reviewListUpdateRequest)
            .disposed(by: disposeBag)
    }
}
