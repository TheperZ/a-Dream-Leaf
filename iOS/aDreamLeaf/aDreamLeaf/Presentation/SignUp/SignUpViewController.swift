//
//  SignUpViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SignUpViewModel
    
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    private let emailUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let pwdLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let pwdTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let pwdUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let pwdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let pwdCheckTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let pwdCheckUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainColor")
        button.setTitle("회원가입 하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        attribute()
        layout()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindViewModel() {
        
        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty.asDriver(),
                                          passsword: pwdTextField.rx.text.orEmpty.asDriver(),
                                          passwordCheck: pwdCheckTextField.rx.text.orEmpty.asDriver(),
                                          trigger: signUpButton.rx.tap.asDriver())
        
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
                    let alert = UIAlertController(title: "성공", message: "이메일 인증 후 로그인 해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                } else {

                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        [loadingView, titleLabel, emailLabel, emailTextField, emailUnderLine, pwdLabel, pwdTextField, pwdUnderLine, pwdCheckLabel, pwdCheckTextField, pwdCheckUnderLine, signUpButton].forEach {
            contentView.addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(50)
            $0.centerX.equalTo(view)
            $0.width.equalTo(300)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }

        emailUnderLine.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(1)
        }
        
        pwdLabel.snp.makeConstraints {
            $0.top.equalTo(emailUnderLine.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        pwdTextField.snp.makeConstraints {
            $0.top.equalTo(pwdLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }

        pwdUnderLine.snp.makeConstraints {
            $0.top.equalTo(pwdTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(1)
        }
        
        pwdCheckLabel.snp.makeConstraints {
            $0.top.equalTo(pwdUnderLine.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        pwdCheckTextField.snp.makeConstraints {
            $0.top.equalTo(pwdCheckLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }

        pwdCheckUnderLine.snp.makeConstraints {
            $0.top.equalTo(pwdCheckTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(1)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(pwdCheckUnderLine.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(45)
            $0.bottom.equalTo(contentView).offset(-20)
        }
    
    }

}
