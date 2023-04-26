//
//  StartViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class StartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: StartViewModel
    
    private let stackView = UIStackView()
    private let imageView = UIImageView(image: UIImage(named: "Icon"))
    private let titleLabel = UILabel()
    
    init() {
        viewModel = StartViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loginCheckRequest.accept(Void())
    }
    
    private func bind() {
        viewModel.isLogInChecked
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
                let vc = MainViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        
        titleLabel.text = "꿈나무 한잎"
        titleLabel.textColor = UIColor(red: 0.71, green: 0.87, blue: 0.46, alpha: 1.00)
        titleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        titleLabel.textAlignment = .center
    }
    
    private func layout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, titleLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 280),
            imageView.heightAnchor.constraint(equalToConstant: 280),
        ].forEach { $0.isActive = true }
    }
    
    
}
