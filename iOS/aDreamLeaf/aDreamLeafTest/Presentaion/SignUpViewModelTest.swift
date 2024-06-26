//
//  SignUpViewModelTest.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/8/23.
//

@testable import aDreamLeaf
import RxSwift
import XCTest
import RxTest

final class SignUpViewModelTest:XCTestCase {
    var disposeBag: DisposeBag!
    var repository: MockSignUpRepository!
    var viewModel: SignUpViewModel!
    
    //Input
    var email: BehaviorSubject<String>!
    var password: BehaviorSubject<String>!
    var passwordCheck: BehaviorSubject<String>!
    var trigger: PublishSubject<Void>!
    
    //Output
    var result: TestableObserver<Result<Void, Error>>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = MockSignUpRepository()
        viewModel = SignUpViewModel(repository)
        
        email = BehaviorSubject<String>(value: "")
        password = BehaviorSubject<String>(value: "")
        passwordCheck = BehaviorSubject<String>(value: "")
        trigger = PublishSubject<Void>()
        
        let testScheduler = TestScheduler(initialClock: 0)
        result = testScheduler.createObserver(Result<Void, Error>.self)
        
        let input = SignUpViewModel.Input(email: email.asDriver(onErrorJustReturn: ""),
                                          password: password.asDriver(onErrorJustReturn: ""),
                                          passwordCheck: passwordCheck.asDriver(onErrorJustReturn: ""),
                                          trigger: trigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        output.result.drive(result).disposed(by: disposeBag)
        
    }
    
    func test_Trigger_withNoInput() {
        //when
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.emptyEmail)
            default:
                break
        }
    }
    
    func test_Trigger_withEmailOnly() {
        //when
        email.onNext("asd@asd.com")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.emptyPassword)
            default:
                break
        }
    }
    
    func test_Trigger_withDifferentPassword() {
        //when
        email.onNext("asd@asd.com")
        password.onNext("asdasd")
        passwordCheck.onNext("qweqwe")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.differentPassword)
            default:
                break
        }
    }
    
    func test_Trigger_withWrongFormatEmail() {
        //when
        email.onNext("asd@asd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.invalidEmailFormat)
            default:
                break
        }
    }
    
    func test_Trigger_withWrongFormatEmail2() {
        //when
        email.onNext("asdasdawd")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.invalidEmailFormat)
            default:
                break
        }
    }
    
    func test_Trigger_withShortPassword() {
        //when
        email.onNext("asdasdawd@naver.com")
        password.onNext("123")
        passwordCheck.onNext("123")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as! MockSignUpRepository.MockLoginRepositoryError, MockSignUpRepository.MockLoginRepositoryError.shortPassword)
            default:
                break
        }
    }
    
    func test_Trigger_withPerfectInput() {
        //when
        email.onNext("asd@asd.com")
        password.onNext("123123")
        passwordCheck.onNext("123123")
        trigger.onNext(())
        
        //then
        XCTAssertEqual(result.events.count, 1)
        switch result.events[0].value.element {
            case let .failure(error):
                XCTFail()
            default:
                break
        }
    }
    
    
}
