//
//  LoadingViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/08/08.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let loadingViewModel: LoadingViewModel
    let loadingView = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: LoadingViewModel) {
        self.loadingViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting() {
        loadingView.backgroundColor = UIColor(white: 1, alpha: 1)
        
        loadingViewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { loading in
                if loading {
                    self.loadingView.startAnimating()
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setActivityIndicatorViewAlpha(to: UIColor) {
        loadingView.backgroundColor = to
    }
}
