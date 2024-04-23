////
////  AccountSettingViewModelTest.swift
////  aDreamLeafNetworkTests
////
////  Created by 엄태양 on 12/6/23.
////
//
//@testable import aDreamLeaf
//import XCTest
//import RxSwift
//import RxTest
//
//final class AccountSettingViewModelTest: XCTestCase {
//    var disposeBag: DisposeBag!
//    var accountRepo: MockAccountRepository!
//    var alarmRepo: MockAlarmRepository!
//    var viewModel: AccountSettingViewModel!
//    
//    //input
//    var trigger: PublishSubject<Void>!
//    var budget: PublishSubject<Int>!
//    var budgetTrigger: PublishSubject<Void>!
//    var alarmTrigger: PublishSubject<Void>!
//    
//    
//    //output
//    var alarm: TestableObserver<Bool>!
//    var budgetResult: TestableObserver<RequestResult<Void>>!
//    
//    override func setUp() {
//        disposeBag = DisposeBag()
//        accountRepo = MockAccountRepository()
//        alarmRepo = MockAlarmRepository()
//        viewModel = AccountSettingViewModel(accountRepo, alarmRepo)
//        
//        trigger = PublishSubject<Void>()
//        budget = PublishSubject<Int>()
//        budgetTrigger = PublishSubject<Void>()
//        alarmTrigger = PublishSubject<Void>()
//        
//        let testScheduler = TestScheduler(initialClock: 0)
//        alarm = testScheduler.createObserver(Bool.self)
//        budgetResult = testScheduler.createObserver(RequestResult<Void>.self)
//        
//        let input = AccountSettingViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
//                                                  budget: budget.asDriver(onErrorJustReturn: 0),
//                                                  budgetTrigger: budgetTrigger.asDriver(onErrorJustReturn: ()), 
//                                                  alarmTrigger: alarmTrigger.asDriver(onErrorJustReturn: ()))
//        
//        let output = viewModel.transform(input: input)
//        
//        output.alarm.drive(alarm).disposed(by: disposeBag)
//        output.budgetResult.drive(budgetResult).disposed(by: disposeBag)
//    }
//    
//    func test_fetch_initAlarmState() {
//        //when
//        trigger.onNext(())
//        
//        //then
//        XCTAssertEqual(alarm.events.count, 1)
//    }
//    
//    func test_toggleAlarmSwitch() {
//        //given
//        trigger.onNext(())
//        
//        //when
//        alarmTrigger.onNext(())
//        
//        //then
//        XCTAssertEqual(alarm.events.count, 2)
//        
//    }
//    
//    func test_budgetTrigger_withOutBudget() {
//        //when
//        budgetTrigger.onNext(())
//        
//        //then
//        XCTAssertEqual(budgetResult.events.count, 0)
//    }
//    
//    func test_budgetTrigger_withEnteringBudget() {
//        //given
//        budget.onNext(1000)
//        
//        //when
//        budgetTrigger.onNext(())
//        
//        //then
//        XCTAssertEqual(budgetResult.events.count, 1)
//    }
//}
