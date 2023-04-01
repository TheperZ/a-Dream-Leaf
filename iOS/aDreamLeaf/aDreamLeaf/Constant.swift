//
//  Constant.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import Foundation
import UIKit

struct K {
    struct ScreenSize {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
    
    struct TableViewCellID {
        static let SearchCell = "SearchCell"
        static let SimpleReviewCell = "SimpleReviewCell"
    }
    
    struct CollectionViewCellID {
        static let RestaurantCell = "RestaurantCell"
    }
}
