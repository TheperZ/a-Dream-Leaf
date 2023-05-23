//
//  ReviewViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewViewModel {
    private let disposeBag = DisposeBag()
    
    let rating = BehaviorSubject<Int>(value: 5)
    let body = BehaviorSubject<String>(value: "")
    
    let saveBtnTap = PublishSubject<Void>()
    
    init() {
        saveBtnTap
            .withLatestFrom(Observable.combineLatest(rating, body))
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
