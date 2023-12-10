//
//  ExpenditureDetailViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/6/23.
//


@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class ExpenditureDetailViewModelTest: XCTestCase {
    let expenditureSample = Expenditure(userId: 1, accountId: 1, restaurant: "Some Store", price: 123, date: "2023-12-01", body: "점심")
    var disposeBag: DisposeBag!
    var repository: MockAccountRepository!
    var viewModel: ExpenditureDetailViewModel!
    
    
    //Input
    var deleteTrigger: PublishSubject<Void>!
    
    //Output
    var expenditure: Expenditure!
    var result: TestableObserver<RequestResult<Void>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockAccountRepository()
        viewModel = ExpenditureDetailViewModel(data: expenditureSample, repository)
        
        deleteTrigger = PublishSubject<Void>()
        
        let testScheduler = TestScheduler(initialClock: 0)
        result = testScheduler.createObserver(RequestResult<Void>.self)
        
        let input = ExpenditureDetailViewModel.Input(deleteTrigger: deleteTrigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        
        
        
        expenditure = output.expenditure
        output.result.drive(result).disposed(by: disposeBag)
    }
    
    func test_deleteTrigger() {
        //when
        deleteTrigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
    }
}
