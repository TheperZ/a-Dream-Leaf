//
//  SimpleReviewCellViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import Foundation
import RxSwift
import RxRelay

struct SimpleReviewCellViewModel {
    let disposeBag = DisposeBag()
    let nickname: String
    let content: String
    
    init(_ with: Review) {
        self.nickname = with.userName
        self.content = with.body
    }
}
