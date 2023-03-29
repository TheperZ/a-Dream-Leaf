//
//  UIView.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import UIKit

extension UIView {
    func addTapGesture(cancelsTouchesInViewOption: Bool = true) {
        let tg = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler(_:)))
        tg.cancelsTouchesInView = cancelsTouchesInViewOption
        self.addGestureRecognizer(tg)
    }
    
    @objc
    func tapGestureHandler(_ sender: UITapGestureRecognizer? = nil) {
        self.endEditing(true)
    }
}
