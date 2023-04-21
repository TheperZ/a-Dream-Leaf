//
//  LoginViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: LoginViewModel
    
    private let backButton = UIBarButtonItem()
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailUnderLine = UIView()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordUnderLine = UIView()
    
    private let loginButton = UIButton()
    private let signInButton = UIButton()
    private let pwdFindButton = UIButton()
    
    init() {
        viewModel = LoginViewModel()
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
        
        signInButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginBtnTap)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.pwd)
            .disposed(by: disposeBag)
        
        viewModel.loginResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.success {
                    UserManager.login(userData: $0.userData)
                    self.dismiss(animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: $0.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
        let backButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let backButtonImg = UIImage(systemName: "chevron.left", withConfiguration: backButtonConfig)?.withRenderingMode(.alwaysTemplate)
        backButton.image = backButtonImg
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
        
        titleLabel.text = "꿈나무 한입"
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        emailLabel.text = "이메일"
        emailLabel.textColor = .black
        emailLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        emailTextField.textColor = .black
        emailTextField.font = .systemFont(ofSize: 20, weight: .regular)
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailUnderLine.backgroundColor = .lightGray
        
        passwordLabel.text = "비밀번호"
        passwordLabel.textColor = .black
        passwordLabel.font = .systemFont(ofSize: 13, weight: .semibold)
    
        passwordTextField.textColor = .black
        passwordTextField.font = .systemFont(ofSize: 20, weight: .regular)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordUnderLine.backgroundColor = .lightGray
        
        loginButton.backgroundColor = UIColor(named: "mainColor")
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 10
        
        signInButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        signInButton.setTitle("회원가입", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.layer.cornerRadius = 10
        
        pwdFindButton.backgroundColor = .clear
        pwdFindButton.setTitle("비밀번호 찾기", for: .normal)
        pwdFindButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        pwdFindButton.setTitleColor(.gray, for: .normal)
        
    }
    
    private func layout() {
        
        [contentView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        [titleLabel, emailLabel, emailTextField, emailUnderLine, passwordLabel, passwordTextField, passwordUnderLine, loginButton, signInButton, pwdFindButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            contentView.widthAnchor.constraint(equalToConstant: 300),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.bottomAnchor.constraint(equalTo: pwdFindButton.bottomAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailUnderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailUnderLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailUnderLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            passwordLabel.topAnchor.constraint(equalTo: emailUnderLine.bottomAnchor, constant: 30),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            passwordUnderLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordUnderLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordUnderLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passwordUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            loginButton.topAnchor.constraint(equalTo: passwordUnderLine.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            
            signInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            
            pwdFindButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            pwdFindButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pwdFindButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pwdFindButton.heightAnchor.constraint(equalToConstant: 45),
            
            
        ].forEach{ $0.isActive = true }
    }
}
