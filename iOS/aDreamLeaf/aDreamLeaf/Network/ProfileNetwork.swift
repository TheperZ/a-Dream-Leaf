//
//  ProfileNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/25.
//

import Foundation
import FirebaseAuth
import RxSwift

struct ProfileNetwork {
    func deleteAccountFB() -> Observable<RequestResult<Void>> {
        return Observable.create { observer in
            
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    observer.onNext(RequestResult(success: false, msg: "오류가 발생했습니다.\n잠시후에 다시 시도 해주세요."))
                }
                
                observer.onNext(RequestResult(success: true, msg: nil))
            }
            
            return Disposables.create()
        }
    }
}
