//
//  LoginViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/7/23.
//

@testable import aDreamLeaf
import XCTest
import RxTest
import RxSwift

final class LoginViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var repository: MockLoginRepository!
    var viewModel: LoginViewModel!
    
    //input
    var trigger: PublishSubject<Void>!
    var email: PublishSubject<String>!
    var pwd: PublishSubject<String>!
    
    //output
    var result: TestableObserver<Result<Void, Error>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockLoginRepository()
        viewModel = LoginViewModel(repository)
        
        trigger = PublishSubject<Void>()
        email = PublishSubject<String>()
        pwd = PublishSubject<String>()
        
        let input = LoginViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()),
                                         email: email.asDriver(onErrorJustReturn: ""),
                                         pwd: pwd.asDriver(onErrorJustReturn: ""))
        
        let output = viewModel.transform(input: input)
        
        let testScheduler = TestScheduler(initialClock: 0)
        result = testScheduler.createObserver(Result<Void, Error>.self)
        
        output.result.drive(result).disposed(by: disposeBag)
    }
    
    func test_trigger_withNoEmailAndNoPassword() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockLoginRepository.MockLoginRepositoryError, MockLoginRepository.MockLoginRepositoryError.emptyEmail)
            default:
                break
        }
    }
    
    func test_trigger_withRightEmailAndNoPassword() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        email.onNext("asd@asd.com")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockLoginRepository.MockLoginRepositoryError, MockLoginRepository.MockLoginRepositoryError.emptyPassword)
            default:
                break
        }
    }
    
    
    func test_trigger_withWrongEmailAndShortPassword2() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        email.onNext("email@asdf")
        pwd.onNext("asd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockLoginRepository.MockLoginRepositoryError, MockLoginRepository.MockLoginRepositoryError.invalidEmailFormat)
            default:
                break
        }
    }
    
    func test_trigger_withNoEmailAndShortPassword() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        email.onNext("")
        pwd.onNext("asd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockLoginRepository.MockLoginRepositoryError, MockLoginRepository.MockLoginRepositoryError.emptyEmail)
            default:
                break
        }
    }
    
    func test_trigger_withRightEmailAndShortPassword() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        email.onNext("asd@asdf.com")
        pwd.onNext("asd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockLoginRepository.MockLoginRepositoryError, MockLoginRepository.MockLoginRepositoryError.shortPassword)
            default:
                break
        }
    }
    
    func test_trigger_withRightEmailAndPassword() {
        //given
        email.onNext("")
        pwd.onNext("")
        
        //when
        email.onNext("asdf@asd.com")
        pwd.onNext("asdasd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
    }
}
