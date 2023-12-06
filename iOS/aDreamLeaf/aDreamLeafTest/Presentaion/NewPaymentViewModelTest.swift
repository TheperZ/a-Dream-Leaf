//
//  NewPaymentViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/5/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest


final class NewPaymentViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var repository: MockAccountRepository!
    var viewModel: NewPaymentViewModel!
    
    //Input
    var trigger: PublishSubject<Void>!
    var date: BehaviorSubject<Date>!
    var store: BehaviorSubject<String>!
    var content: BehaviorSubject<String>!
    var cost: BehaviorSubject<Int>!
    
    //Output
    var result: TestableObserver<RequestResult<Void>>!
    var editData: Expenditure!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockAccountRepository()
        
        trigger = PublishSubject<Void>()
        date = BehaviorSubject<Date>(value: .now)
        store = BehaviorSubject<String>(value: "")
        content = BehaviorSubject<String>(value: "")
        cost = BehaviorSubject<Int>(value: -1)
    }
    
    func test_enterOnlyStoreName_inCreateMode() {
        //given
        configCreateMode()
        
        //when
        store.onNext("Some Store")
        trigger.onNext(())
        
        //then
        XCTAssertNil(editData)
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, false)
        XCTAssertEqual(result.events[0].value.element!.msg, "가격을 입력해주세요.")
        
    }
    
    func test_enterOnlyCost_inCreateMode() {
        //given
        configCreateMode()
        
        
        //when
        cost.onNext(123123)
        trigger.onNext(())
        
        //then
        XCTAssertNil(editData)
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, false)
        XCTAssertEqual(result.events[0].value.element!.msg, "가게명을 입력해주세요.")
    }
    
    func test_enterStoreNameAndCost_inCreateMode() {
        //given
        configCreateMode()
        
        //when
        store.onNext("Some Store")
        cost.onNext(123123)
        trigger.onNext(())
        
        //then
        XCTAssertNil(editData)
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
        XCTAssertEqual(result.events[0].value.element!.msg, "create")
    }
    
    func test_initalization_inEditMode() {
        //given
        let data = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123123, date: "2023-12-03", body: "점심식사")
        configEditMode(data: data)
        
        //then
        XCTAssertNotNil(editData)
    }
    
    func test_tapSaveButtonWithoutChanging_inEditMode() {
        //given
        let data = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123123, date: "2023-12-03", body: "점심식사")
        configEditMode(data: data)
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    func test_tapSaveButton_AfterChangeStoreName_inEditMode() {
        //given
        let data = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123123, date: "2023-12-03", body: "점심식사")
        configEditMode(data: data)
        
        //when
        store.onNext("Other Store")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    func test_tapSaveButton_AfterChangeCost_inEditMode() {
        //given
        let data = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123123, date: "2023-12-03", body: "점심식사")
        configEditMode(data: data)
        
        //when
        cost.onNext(10)
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    func test_tapSaveButton_AfterChangeBody_inEditMode() {
        //given
        let data = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123123, date: "2023-12-03", body: "점심식사")
        configEditMode(data: data)
        
        //when
        content.onNext("저녁식사")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
        XCTAssertEqual(result.events[0].value.element!.msg, "update")
    }
    
    
    private func configCreateMode() { // 지출 내역 추가
        viewModel = NewPaymentViewModel(repository)
        let input = NewPaymentViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
                                              date: date.asDriver(onErrorJustReturn: .now), store: store.asDriver(onErrorJustReturn: ""), content: content.asDriver(onErrorJustReturn: ""), cost: cost.asDriver(onErrorJustReturn: 0))
        
        let output = viewModel.transform(input: input)
        
        let testScheduler = TestScheduler(initialClock: 0)
        result = testScheduler.createObserver(RequestResult<Void>.self)
        
        output.result.drive(result).disposed(by: disposeBag)
        editData = output.editData
    }
    
    private func configEditMode(data: Expenditure) { // 지출 내역 수정
        viewModel = NewPaymentViewModel(repository, data: data)
        let input = NewPaymentViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
                                              date: date.asDriver(onErrorJustReturn: .now), store: store.asDriver(onErrorJustReturn: ""), content: content.asDriver(onErrorJustReturn: ""), cost: cost.asDriver(onErrorJustReturn: 0))
        
        let output = viewModel.transform(input: input)
        
        let testScheduler = TestScheduler(initialClock: 0)
        result = testScheduler.createObserver(RequestResult<Void>.self)
        
        output.result.drive(result).disposed(by: disposeBag)
        editData = output.editData
    }
}

