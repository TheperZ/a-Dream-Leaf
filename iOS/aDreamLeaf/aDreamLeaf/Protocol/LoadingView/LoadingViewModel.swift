//
//  LoadingViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/08/08.
//

import Foundation
import RxSwift
import RxRelay

protocol LoadingViewModel {
    var loading: PublishSubject<Bool> { get set }
}
