//
//  PwdResetViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/7/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class PwdResetViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var repository: MockLoginRepository!
    var viewModel: PwdResetViewModel!
    
    //input
    var trigger: PublishSubject<Void>!
    var email: PublishSubject<String>!
    
    //output
    var result: TestableObserver<RequestResult<Void>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockLoginRepository()
        viewModel = PwdResetViewModel(repository)
        
        trigger = PublishSubject<Void>()
        email = PublishSubject<String>()
        
        let input = PwdResetViewModel.Input(email: email.asDriver(onErrorJustReturn: ""),
                                            trigger: trigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        
        let testScheduler = TestScheduler(initialClock: 0)
        
        result = testScheduler.createObserver(RequestResult<Void>.self)
        output.result.drive(result).disposed(by: disposeBag)
    }
    
    func test_trigger_withRightEmail() {
        //given
        email.onNext("")
        
        //when
        email.onNext("asd@asd.com")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, true)
    }
    
    func test_trigger_withNoEmail() {
        //given
        email.onNext("")
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, false)
        XCTAssertEqual(result.events[0].value.element!.msg, "이메일을 입력해주세요.")
    }
    
    func test_trigger_withWrongEmail() {
        //given
        email.onNext("")
        
        //when
        email.onNext("asd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, false)
        XCTAssertEqual(result.events[0].value.element!.msg, "올바르지 못한 이메일 형식입니다.")
    }
    
    func test_trigger_withWrongEmail2() {
        //given
        email.onNext("")
        
        //when
        email.onNext("asd@asda")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        XCTAssertEqual(result.events[0].value.element!.success, false)
        XCTAssertEqual(result.events[0].value.element!.msg, "올바르지 못한 이메일 형식입니다.")
    }
    
    
}
