//
//  MockSignUpRepository.swift
//  aDreamLeafNetworkTests
//
//  Created by 엄태양 on 12/8/23.
//

@testable import aDreamLeaf
import Foundation
import RxSwift

struct MockSignUpRepository: SignUpRepository {
    func signUp(email: String, pwd: String, pwdCheck: String) -> RxSwift.Observable<aDreamLeaf.RequestResult<Void>> {
        let inputValidationResult = validateInput(email: email, pwd: pwd, pwdCheck: pwdCheck)
        
        if inputValidationResult != nil {
            return inputValidationResult!
        }
        
        return Observable.just(RequestResult(success: true, msg: "signUp"))
    }
    
    func sendEmailValification(email: String, pwd: String) {
        print("\n\n Send Email \n\n")
        return
    }
    
    
}
