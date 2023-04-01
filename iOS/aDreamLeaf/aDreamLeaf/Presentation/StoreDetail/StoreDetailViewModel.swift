//
//  StoreDetailViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import Foundation
import RxSwift
import RxRelay

struct StoreDetailViewModel {
    let disposeBag = DisposeBag()
    let reviews = Observable.just([("닉네임1", "맛있게 잘 먹었습니다!"),("닉네임2", "양념이 조금 짜지만 먹을만 했어요"), ("닉네임3", "존맛이에요! 번창하세요~")])
}
