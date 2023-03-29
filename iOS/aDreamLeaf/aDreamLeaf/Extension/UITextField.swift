//
//  UITextField.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        self.leftViewMode = .always
    }
}
