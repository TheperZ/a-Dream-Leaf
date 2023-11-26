//
//  MainViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 95
        tabBar.frame.origin.y = view.frame.height - 95
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor(named: "mainColor")
        self.tabBar.tintColor = UIColor(named: "subColor")
        self.setViewControllers([UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel())), UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel())), UINavigationController(rootViewController: AccountViewController(viewModel: AccountViewModel()))], animated: true)
    }
}
