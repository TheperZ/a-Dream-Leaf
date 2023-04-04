//
//  ReivewListViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewListViewModel {
    let disposeBag = DisposeBag()
    let reviews = Observable.just([("닉네임1", "맛있게 잘 먹었습니다!", 4.5, nil),("닉네임2", "양념이 조금 짜지만 먹을만 했어요", 3.3, UIImage(named: "pizza")), ("닉네임3", "존맛이에요! 번창하세요~", 5.0, nil), ("김상명", "항상 친절하게 맞아주십니다.\n다음에도 꼭 갈게요.\n여러분도 꼭 가보세요!", 5.0, UIImage(named: "pizza2")), ("닉네임5", "제 입맛에는 너무 느끼했어요.. 아쉽네요 🥲", 2.5, nil)])
}
