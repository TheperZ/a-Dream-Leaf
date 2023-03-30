//
//  MyPageViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameContentLabel = UILabel()
    private let nameUnderLine = UIView()
    
    private let emailLabel = UILabel()
    private let emailContentLabel = UILabel()
    private let emailUnderLine = UIView()
    
    private let logoutButton = UIButton()
    private let exitButton = UIButton()
    
    init() {
        viewModel = MyPageViewModel()
        
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
    
    private func bind() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        view.backgroundColor = .white
        
        let backButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let backButtonImg = UIImage(systemName: "chevron.left", withConfiguration: backButtonConfig)?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImg, for: .normal)
        backButton.tintColor = .black
        
        titleLabel.text = "마이페이지"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        [nameLabel, emailLabel].forEach {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        nameLabel.text = "이름"
        emailLabel.text = "이메일"
        
        [nameContentLabel, emailContentLabel].forEach {
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.textAlignment = .right
            
        }
        
        nameContentLabel.text = "김상명"
        emailContentLabel.text = "kim@smu.ac.kr"
        
        [nameUnderLine, emailUnderLine].forEach {
            $0.backgroundColor = .lightGray
        }
        
        logoutButton.backgroundColor = UIColor(named: "mainColor")
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.layer.cornerRadius = 10
        
        exitButton.backgroundColor = .lightGray
        exitButton.setTitle("계정 탈퇴", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.layer.cornerRadius = 10
        
    }
    
    private func layout() {
        [backButton,titleLabel, nameLabel, nameContentLabel, nameUnderLine, emailLabel, emailContentLabel, emailUnderLine, logoutButton, exitButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nameContentLabel.leadingAnchor),
            
            nameContentLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameContentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            nameUnderLine.topAnchor.constraint(equalTo: nameContentLabel.bottomAnchor, constant: 15),
            nameUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nameUnderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            emailLabel.topAnchor.constraint(equalTo: nameUnderLine.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: emailContentLabel.leadingAnchor),
            
            emailContentLabel.topAnchor.constraint(equalTo: emailLabel.topAnchor),
            emailContentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            emailUnderLine.topAnchor.constraint(equalTo: emailContentLabel.bottomAnchor, constant: 15),
            emailUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            emailUnderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            logoutButton.topAnchor.constraint(equalTo: emailUnderLine.bottomAnchor, constant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            
            exitButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 40)
            
        ].forEach { $0.isActive = true }
    }
    
}
