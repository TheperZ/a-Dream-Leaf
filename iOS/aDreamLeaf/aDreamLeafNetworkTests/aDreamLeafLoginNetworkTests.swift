//
//  aDreamLeafLoginNetworkTests.swift
//  aDreamLeafLoginNetworkTests
//
//  Created by 엄태양 on 2023/09/20.
//

import XCTest

@testable import aDreamLeaf
import RxSwift
import RxRelay

final class aDreamLeafLoginNetworkTests: XCTestCase {
    
    private let network = LoginNetwork(type: .Login)
    private let disposeBag = DisposeBag()
    
    func testLoginFBWithCorrectEmailAndPassword() throws {
        let email = Bundle.main.object(forInfoDictionaryKey: "TEST_EMAIL") as! String
        let pwd = Bundle.main.object(forInfoDictionaryKey: "TEST_PASSWORD") as! String
        let expectation = XCTestExpectation(description: "네트워크 요청 대기")
        
        network.loginRequestFB(email: email, pwd: pwd)
            .subscribe(onNext:{ result in
                XCTAssertEqual(result.success, true)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLoginServerWithCorrectEmailAndPassword() throws {
        let email = Bundle.main.object(forInfoDictionaryKey: "TEST_EMAIL") as! String
        let pwd = Bundle.main.object(forInfoDictionaryKey: "TEST_PASSWORD") as! String
        let expectation = XCTestExpectation(description: "네트워크 요청 대기")
        
        network.loginRequestServer(email: email, pwd: pwd)
            .subscribe(onNext: { result in
                XCTAssertEqual(result.success, true)
                XCTAssertNotNil(result.data)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }

}
