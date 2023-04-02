//
//  ReviewCellVIewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import Foundation
import RxSwift
import RxRelay

struct ReviewCellVIewModel {
    let disposeBag = DisposeBag()
    let nickname: String
    let content: String
    let rating: Double
    let image: UIImage?
    
    init(nickname: String, content: String, rating: Double, image: UIImage?) {
        self.nickname = nickname
        self.content = content
        self.rating = rating
        self.image = image
    }
}
