//
//  ProfileRepository.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 12/4/23.
//

import Foundation
import RxSwift

protocol ProfileRepository {
    func deleteAccount() -> Observable<Result<Void, Error>>
}
