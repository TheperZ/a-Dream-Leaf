//
//  MyPageViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import Foundation
import RxSwift
import RxRelay

struct MyPageViewModel {
    private let disposeBag = DisposeBag()
    let email = UserManager.getInstance().map{ $0?.email ?? "" }
    let nickname = UserManager.getInstance().map{ $0?.nickname ?? "" }
}
