//
//  UserManager.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/19.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

struct UserManager {
    
    private static let user = BehaviorSubject<User?>(value: nil)
    private static var isLogin = false
    
    private init() {}
    
    static func getInstance() -> BehaviorSubject<User?> {
        return UserManager.user
    }
    
    static func login(userData: User?) {
        if let userData = userData {
            UserDefaults.standard.setValue(userData.uid, forKey: "uid")
            UserDefaults.standard.setValue(userData.email, forKey: "email")
            UserDefaults.standard.setValue(userData.password, forKey: "password")
            UserDefaults.standard.setValue(userData.nickname, forKey: "nickname")
            isLogin = true
        }
        
        self.user.onNext(userData)
    }
        
    static func logout() {
        self.user.onNext(nil)
        
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "nickname")

    }

}
