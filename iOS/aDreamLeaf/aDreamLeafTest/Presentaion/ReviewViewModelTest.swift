//
//  ReviewViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/11/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class ReviewViewModelTest: XCTestCase {
    let tempReview = Review(userId: 1, userName: "name1", reviewId: 1, storeId: 1, storeName: "Store1", date: "2023-03-11", body: "좋아요!", rating: 3)
    
    var disposeBag: DisposeBag!
    var repository: MockReviewRepository!
    var viewModel: ReviewViewModel!
    
    //Input
    var trigger: PublishSubject<Void>!
    var rating: PublishSubject<Int>!
    var body: PublishSubject<String>!
    var image: PublishSubject<UIImage?>!
    
    //Output
    var isEdit: Bool!
    var editData: Review?
    var result: TestableObserver<RequestResult<Void>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockReviewRepository()
        viewModel = ReviewViewModel(storeId: 1)
        
        trigger = PublishSubject<Void>()
        rating = PublishSubject<Int>()
        body = PublishSubject<String>()
        image = PublishSubject<UIImage?>()
    }
    
    private func configCreateMode() { // 지출 내역 추가
        viewModel = ReviewViewModel(storeId: 1, repository)
        
        let testScheduelr = TestScheduler(initialClock: 0)
        result = testScheduelr.createObserver(RequestResult<Void>.self)
        
        let input = ReviewViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
                                          rating: rating.asDriver(onErrorJustReturn: 0),
                                          body: body.asDriver(onErrorJustReturn: ""),
                                          image: image.asDriver(onErrorJustReturn: nil))
        
        let output = viewModel.transform(input: input)
        output.result.drive(result).disposed(by: disposeBag)
        isEdit = false
        editData = nil
    }
    
    private func configEditMode() { // 지출 내역 수정
        viewModel = ReviewViewModel(storeId: 1, editData: tempReview, repository)
        
        let testScheduelr = TestScheduler(initialClock: 0)
        result = testScheduelr.createObserver(RequestResult<Void>.self)
        
        let input = ReviewViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
                                          rating: rating.asDriver(onErrorJustReturn: 0),
                                          body: body.asDriver(onErrorJustReturn: ""),
                                          image: image.asDriver(onErrorJustReturn: nil))
        
        let output = viewModel.transform(input: input)
        output.result.drive(result).disposed(by: disposeBag)
        isEdit = output.isEdit
        editData = output.editData
    }
    
    
    //MARK: - Create Mode
    func test_init_InCreateMode() {
        //given
        configCreateMode()
        
        //then
        XCTAssertEqual(isEdit, false)
        XCTAssertNil(editData)
    }
    
    func test_trigger_withInput_InCreateMode() {
        //given
        configCreateMode()
        
        //when
        rating.onNext(3)
        body.onNext("맛있어요")
        image.onNext(nil)
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.msg, "create")
    }
    
    //MARK: - Edit Mode
    
    func test_init_InEditMode() {
        //given
        configEditMode()
        
        //then
        XCTAssertEqual(isEdit, true)
        XCTAssertNotNil(editData)
    }
    
    func test_trigger_withNoInput_InEditMode() {
        //given
        configEditMode()
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    func test_trigger_withInput_InEditMode() {
        //given
        configEditMode()
        
        //when
        rating.onNext(3)
        body.onNext("맛있어요")
        image.onNext(nil)
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    
}
