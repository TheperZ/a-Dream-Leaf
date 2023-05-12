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
    
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let nicknameContentLabel = UILabel()
    private let nicknameUnderLine = UIView()
    
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
        viewModel.loading
            .subscribe(onNext: { isLoading in
                if isLoading {
                    self.loadingView.startAnimating()
                } else {
                    self.loadingView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .asDriver()
            .drive(onNext: {
                UserManager.logout()
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "경고", message: "한번 삭제한 계정은 복구할 수 없습니다.\n삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.viewModel.deleteAccountBtnTap.onNext(Void())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: "그 동안 이용해주셔서 감사합니다.", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    
                    alert.addAction(confirm)
                    
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg , preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    
                    alert.addAction(confirm)
                    
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.email
            .observe(on: MainScheduler.instance)
            .bind(to: emailContentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .observe(on: MainScheduler.instance)
            .bind(to: nicknameContentLabel.rx.text)
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
        
        [nicknameLabel, emailLabel].forEach {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        nicknameLabel.text = "닉네임"
        emailLabel.text = "이메일"
        
        [nicknameContentLabel, emailContentLabel].forEach {
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.textAlignment = .right
            
        }
        
        [nicknameUnderLine, emailUnderLine].forEach {
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
        [loadingView, backButton,titleLabel, nicknameLabel, nicknameContentLabel, nicknameUnderLine, emailLabel, emailContentLabel, emailUnderLine, logoutButton, exitButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            nicknameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: nicknameContentLabel.leadingAnchor),
            
            nicknameContentLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            nicknameContentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            nicknameUnderLine.topAnchor.constraint(equalTo: nicknameContentLabel.bottomAnchor, constant: 15),
            nicknameUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nicknameUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nicknameUnderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            emailLabel.topAnchor.constraint(equalTo: nicknameUnderLine.bottomAnchor, constant: 30),
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

extension MyPageViewController {
    func loadingSetting() {
        
        loadingView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
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
}
