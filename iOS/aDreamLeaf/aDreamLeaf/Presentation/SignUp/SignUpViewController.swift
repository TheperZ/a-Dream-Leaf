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
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25  
        return stackView
    }()
    
    private let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let pwdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let pwdCheckStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
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
                                          password: pwdTextField.rx.text.orEmpty.asDriver(),
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
                
                switch result {
                        
                    case .success:
                        let alert = UIAlertController(title: "성공", message: "이메일 인증 후 로그인 해주세요", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                            self?.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(confirm)
                        self?.present(alert, animated: true)
                        
                    case let .failure(error):
                        let alert = UIAlertController(title: "실패", message: error.localizedDescription, preferredStyle: .alert)
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
        
        [scrollView, loadingView].forEach {
            view.addSubview($0)
        }
        
        self.scrollView.addSubview(contentView)
        
        [titleLabel, emailStackView, pwdStackView, pwdCheckStackView, signUpButton].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [emailLabel, emailTextField, emailUnderLine].forEach {
            emailStackView.addArrangedSubview($0)
        }
        
        [pwdLabel, pwdTextField, pwdUnderLine].forEach {
            pwdStackView.addArrangedSubview($0)
        }
        
        [pwdCheckLabel, pwdCheckTextField, pwdCheckUnderLine].forEach {
            pwdCheckStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(topStackView)
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.width.equalTo(scrollView)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(50)
            $0.leading.equalTo(contentView).offset(30)
            $0.trailing.equalTo(contentView).offset(-30)
            $0.bottom.equalTo(contentView).offset(-30)
        }

        emailUnderLine.snp.makeConstraints {
            $0.height.equalTo(1)
        }

        pwdUnderLine.snp.makeConstraints {
            $0.height.equalTo(1)
        }

        pwdCheckUnderLine.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        

    }

}
