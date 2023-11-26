//
//  StartViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import SnapKit

class StartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: StartViewModel
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let imageView = UIImageView(image: UIImage(named: "Icon"))
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꿈나무 한입"
        label.textColor = .white
        label.font = UIFont(name: "LINESeedSansKR-Bold", size: 35)
        label.textAlignment = .center
        return label
    }()
    
    init() {
        viewModel = StartViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.config()
        
        bindViewModel()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).map { _ in ()}.asDriver(onErrorJustReturn: ())
        
        let input = StartViewModel.Input(trigger: viewDidAppear)
        
        let output = viewModel.tranform(input: input)
        
        output.result
            .drive(onNext: { _ in
                let vc = MainViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "launchColor")
    }
    
    private func layout() {
        view.addSubview(stackView)
        
        [imageView, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(280)
        }
    }
}
