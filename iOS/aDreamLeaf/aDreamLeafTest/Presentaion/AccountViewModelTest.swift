//
//  AccountViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/4/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class AccountViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var repository: MockAccountRepository!
    var viewModel: AccountViewModel!
    
    //Input
    var trigger: PublishSubject<Date>!
    var select: PublishSubject<IndexPath>!
    
    //Output
    var expenditures: TestableObserver<[Expenditure]>!
    var selectedExpenditure: TestableObserver<Expenditure>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockAccountRepository()
        viewModel = AccountViewModel(repository)
        
        trigger = PublishSubject<Date>()
        select = PublishSubject<IndexPath>()
        
        let testScheduler = TestScheduler(initialClock: 0)
        expenditures = testScheduler.createObserver([Expenditure].self)
        selectedExpenditure = testScheduler.createObserver(Expenditure.self)
        
        let input = AccountViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: .now),
                                           select: select.asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0)))
        
        let output = viewModel.tranform(input: input)
        
        output.expenditures.drive(expenditures).disposed(by: disposeBag)
        output.selectedExpenditure.drive(selectedExpenditure).disposed(by: disposeBag)
    }
    
    func test_afterChangeDate_fetchExpenditureList() {
        //given
        let date1 = getTestDate(dateString: "2023-10-11")
        let date2 = getTestDate(dateString: "2023-11-11")
    
        //when
        trigger.onNext(date1)
        trigger.onNext(date2)
        
        //then
        XCTAssertEqual(expenditures.events.count, 2)
        XCTAssertEqual(expenditures.events[0].value.element![0].date, "2023-10")
        XCTAssertEqual(expenditures.events[1].value.element![0].date, "2023-11")
        
    }
    
    func test_selectItemInExpenditureList() {
        //given
        let date = getTestDate(dateString: "2023-12-03")
        
        //when
        trigger.onNext(date)
        select.onNext(IndexPath(row: 1, section: 0))
        
        //then
        XCTAssertEqual(selectedExpenditure.events.count, 1)
        XCTAssertEqual(selectedExpenditure.events[0].value.element!.accountId, repository.expenditureList[3].accountId)
    }
    
    private func getTestDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let date = formatter.date(from: dateString)!
        return date
    }
}
