//
//  aDreamLeafKakaoNetworkTests.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 2023/09/20.
//

import XCTest
@testable import aDreamLeaf
import RxSwift
import RxRelay

final class aDreamLeafKakaoNetworkTests: XCTestCase {

    private let network = KakaoNetwork()
    private let disposeBag = DisposeBag()
    
    private let tempLat = 37.66
    private let tempLgt = 126.7641867

    func testRequestAddressDataWithLocation() throws {
        let expectation = XCTestExpectation(description: "네트워크 요청 대기")
        
        network.getAddress(lat: tempLat, lon: tempLgt)
            .subscribe(onNext:{ result in
                XCTAssertNotNil(result)
                XCTAssertNotNil(result![0].road_address)
                XCTAssertNotNil(result![0].address)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRequestAddressDataWithWeirdLocation() throws {
        let expectation = XCTestExpectation(description: "네트워크 요청 대기")
        
        network.getAddress(lat: 0.0, lon: 0.0)
            .subscribe(onNext:{ result in
                XCTAssertNotNil(result)
                XCTAssertEqual(result!.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }

}
