//
//  MainViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([HomeViewController(), UIViewController()], animated: true)
    }
}
