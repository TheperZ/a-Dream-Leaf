//
//  StoreDetailViewModelTest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/12/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class StoreDetailViewModelTest: XCTest {
    var disposeBag: DisposeBag!
    var storeRepo: MockStoreRepository!
    var reviewRepo: MockReviewRepository!
    var viewModel: StoreDetailViewModel!
    
    //Input
    var trigger: PublishSubject<Void>!
    
    //Output
    var store: TestableObserver<Store?>!
    var reviews: TestableObserver<[Review]>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        storeRepo = MockStoreRepository()
        reviewRepo = MockReviewRepository()
        viewModel = StoreDetailViewModel(storeId: 1, storeRepo, reviewRepo)
        
        trigger = PublishSubject<Void>()
        
        let testScheduler = TestScheduler(initialClock: 0)
        store = testScheduler.createObserver(Store?.self)
        reviews = testScheduler.createObserver([Review].self)
        
        
        let input = StoreDetailViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        output.store.drive(store).disposed(by: disposeBag)
        output.reviews.drive(reviews).disposed(by: disposeBag)
        
    }
    
    func test_inital_trigger() {
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(store.events.count, 1)
        XCTAssertEqual(reviews.events.count, 1)
    }
}
