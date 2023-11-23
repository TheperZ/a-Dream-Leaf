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
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: LoginViewModel
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let backButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let backButtonImg = UIImage(systemName: "chevron.left", withConfiguration: backButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.image = backButtonImg
        button.tintColor = .black
        return button
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꿈나무 한입"
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let emailUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let passwordUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainColor")
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let pwdFindButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(trigger: loginButton.rx.tap.asDriver(),
                                         email: emailTextField.rx.text.orEmpty.asDriver(),
                                         pwd: passwordTextField.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.loading
            .drive(onNext: { [weak self] loading in
                if loading {
                    self?.loadingView.startAnimating()
                    self?.loadingView.isHidden = false
                } else {
                    self?.loadingView.stopAnimating()
                    self?.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext: {[weak self] result in
                if result.success {
                    self?.dismiss(animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func uiEvent() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        signInButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SignUpViewController(viewModel: SignUpViewModel()), animated: true)
            })
            .disposed(by: disposeBag)

        pwdFindButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(PwdResetViewController(viewModel: PwdResetViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func layout() {
        
        [contentView].forEach {
            view.addSubview($0)
        }
        
        
        [loadingView, titleLabel, emailLabel, emailTextField, emailUnderLine, passwordLabel, passwordTextField, passwordUnderLine, loginButton, signInButton, pwdFindButton].forEach {
            contentView.addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.centerX.centerY.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(contentView)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView)
        }
        
        emailUnderLine.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(1)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailUnderLine.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(contentView)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView)
        }
        
        passwordUnderLine.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(1)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordUnderLine.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(45)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(45)
        }
        
        pwdFindButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(10)
            $0.bottom.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(45)
        }
        
    }
}
