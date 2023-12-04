//
//  KakaoRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol KakaoRepository {
    func getMyAddress() -> Observable<String>
}
