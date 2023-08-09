//
//  LoadingViewProtocol.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/08/09.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoadingViewController {
    var disposeBag: DisposeBag { get set }
    var loadingView: UIActivityIndicatorView { get set }
    func configLoadingView(viewModel: LoadingViewModel)
    func setActivityIndicatorViewAlpha(to: UIColor)
}

extension LoadingViewController {
    func configLoadingView(viewModel: LoadingViewModel) {
        loadingView.backgroundColor = UIColor(white: 1, alpha: 1)

        viewModel.loading
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
