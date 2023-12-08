//
//  MyPageViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/8/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class MyPageViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var profileRepo: MockProfileRepository!
    var loginRepo: MockLoginRepository!
    var viewModel: MyPageViewModel!
    
    //Input
    var logoutTrigger: PublishSubject<Void>!
    var deleteTrigger: PublishSubject<Void>!
    
    //output
    var logoutResult: TestableObserver<RequestResult<Void>>!
    var deleteResult: TestableObserver<RequestResult<Void>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        profileRepo = MockProfileRepository()
        loginRepo = MockLoginRepository()
        viewModel = MyPageViewModel(profileRepo, loginRepo)
        
        logoutTrigger = PublishSubject<Void>()
        deleteTrigger = PublishSubject<Void>()
        
        let testScheduler = TestScheduler(initialClock: 0)
        logoutResult = testScheduler.createObserver(RequestResult<Void>.self)
        deleteResult = testScheduler.createObserver(RequestResult<Void>.self)
        
        let input = MyPageViewModel.Input(logoutTrigger: logoutTrigger.asDriver(onErrorJustReturn: ()),
                                          deleteTrigger: deleteTrigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.tranform(input: input)
        
        output.deleteResult.drive(deleteResult).disposed(by: disposeBag)
        output.logoutResult.drive(logoutResult).disposed(by: disposeBag)
        
    }
    
    func test_logoutTrigger() {
        //when
        logoutTrigger.onNext(())
        
        //then
        XCTAssertEqual(logoutResult.events.count, 1)
    }
    
    func test_deleteTrigger() {
        //when
        deleteTrigger.onNext(())
        
        //then
        XCTAssertEqual(deleteResult.events.count, 1)
    }
    
    
}
