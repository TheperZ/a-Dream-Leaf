//
//  SearchViewModelTest.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

@testable import aDreamLeaf
import XCTest
import RxSwift
import RxTest

final class SearchViewModelTest: XCTestCase {
    
    var disposeBag: DisposeBag!
    var repository: MockStoreRepository!
    var viewModel: SearchViewModel!

    //Input
    var keyword: PublishSubject<String>!
    var trigger: PublishSubject<Void>!
    var allTrigger: PublishSubject<Void>!
    var cardTrigger: PublishSubject<Void>!
    var goodTrigger: PublishSubject<Void>!
    var select: PublishSubject<IndexPath>!
    
    //Output
    var stores: TestableObserver<[SimpleStore]>!
    var selectedStore: TestableObserver<SimpleStore>!
    var mode: TestableObserver<Int>!
    
    override func setUp() {
        
        disposeBag = DisposeBag()
        repository = MockStoreRepository()
        viewModel = SearchViewModel(repository)
        
        keyword = PublishSubject<String>()
        trigger = PublishSubject<Void>()
        allTrigger = PublishSubject<Void>()
        cardTrigger = PublishSubject<Void>()
        goodTrigger = PublishSubject<Void>()
        select = PublishSubject<IndexPath>()
        
        let input = SearchViewModel.Input(keyword: keyword.asDriver(onErrorJustReturn: ""),
                                          trigger: trigger.asDriver(onErrorJustReturn: ()),
                                          allTrigger: allTrigger.asDriver(onErrorJustReturn: ()),
                                          cardTrigger: cardTrigger.asDriver(onErrorJustReturn: ()),
                                          goodTrigger: goodTrigger.asDriver(onErrorJustReturn: ()),
                                          select: select.asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0)))
        
        let output = viewModel.tranform(input: input)
        
        
        let testScheduler = TestScheduler(initialClock: 0)
        stores = testScheduler.createObserver([SimpleStore].self)
        selectedStore = testScheduler.createObserver(SimpleStore.self)
        mode = testScheduler.createObserver(Int.self)
    
        output.stores.drive(stores).disposed(by: disposeBag)
        output.selectedStore.drive(selectedStore).disposed(by: disposeBag)
        output.mode.drive(mode).disposed(by: disposeBag)
    }
    
    func test_searchAllStores() {
        keyword.onNext("")
        trigger.onNext(())
    
        
        XCTAssertEqual(stores.events.count, 1)
        XCTAssertEqual(stores.events[0].value.element!.count, 6)
    }
    
    func test_selectSomeStore() {
        keyword.onNext("")
        trigger.onNext(())
        select.onNext(IndexPath(row: 1, section: 0))
        
        
        XCTAssertNotNil(selectedStore.events[0].value.element)
        XCTAssertEqual(selectedStore.events[0].value.element!.storeId, repository.simpleStores[1].storeId)
    }
    
    func test_changeModeAfterSearch() {
        keyword.onNext("")
        trigger.onNext(())
        
        goodTrigger.onNext(())
        cardTrigger.onNext(())
        allTrigger.onNext(())
        
        
        XCTAssertEqual(stores.events.count, 4)
        
        XCTAssertEqual(stores.events[1].value.element!.count, 4)
        XCTAssertEqual(stores.events[1].value.element![0].storeId, 0)
        
        XCTAssertEqual(stores.events[2].value.element!.count, 5)
        XCTAssertEqual(stores.events[2].value.element![0].storeId, 1)
        
        XCTAssertEqual(stores.events[3].value.element!.count, 6)
        XCTAssertEqual(stores.events[3].value.element![0].storeId, 0)
    }
    
    func test_selectSomeStoreAfterChangeMode () {
        keyword.onNext("")
        trigger.onNext(())
        
        cardTrigger.onNext(())
        select.onNext(IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(selectedStore.events[0].value.element!.storeId, repository.simpleStores[3].storeId)
    }
}

