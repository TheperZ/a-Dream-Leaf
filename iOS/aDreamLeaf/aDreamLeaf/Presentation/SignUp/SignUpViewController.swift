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
    
    private let keyboard = PublishRelay<Bool>()
    private var keyboardHeight: CGFloat!
    
    private let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailUnderLine = UIView()
    
    private let pwdLabel = UILabel()
    private let pwdTextField = UITextField()
    private let pwdUnderLine = UIView()
    
    private let pwdCheckLabel = UILabel()
    private let pwdCheckTextField = UITextField()
    private let pwdCheckUnderLine = UIView()
    
    private let signUpButton = UIButton()
    
    init() {
        viewModel = SignUpViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardConfig()
        bind()
        attribute()
        layout()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bind() {
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        pwdTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        pwdCheckTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordCheck)
            .disposed(by: disposeBag)
    
        signUpButton.rx.tap
            .bind(to: viewModel.signUpBtnTap)
            .disposed(by: disposeBag)
        
        viewModel.signUpResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.success {
                    let alert = UIAlertController(title: "성공", message: "이메일 인증 후 로그인 해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                } else {
                    print($0.msg)
                    let alert = UIAlertController(title: "실패", message: "오류가 발생했습니다. 잠시후에 다시 시도해주세요", preferredStyle: .alert)
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
        self.navigationController?.navigationBar.tintColor = .black
        
        titleLabel.text = "회원가입"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        emailLabel.text = "이메일"
        emailLabel.textColor = .black
        emailLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        emailTextField.textColor = .black
        emailTextField.font = .systemFont(ofSize: 20, weight: .regular)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        emailUnderLine.backgroundColor = .lightGray
        
        pwdLabel.text = "비밀번호"
        pwdLabel.textColor = .black
        pwdLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        pwdTextField.textColor = .black
        pwdTextField.font = .systemFont(ofSize: 20, weight: .regular)
        pwdTextField.isSecureTextEntry = true
        pwdUnderLine.backgroundColor = .lightGray
        
        pwdCheckLabel.text = "비밀번호 확인"
        pwdCheckLabel.textColor = .black
        pwdCheckLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        pwdCheckTextField.textColor = .black
        pwdCheckTextField.font = .systemFont(ofSize: 20, weight: .regular)
        pwdCheckTextField.isSecureTextEntry = true
        pwdCheckUnderLine.backgroundColor = .lightGray
        
        signUpButton.backgroundColor = UIColor(named: "mainColor")
        signUpButton.setTitle("회원가입 하기", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, emailLabel, emailTextField, emailUnderLine, pwdLabel, pwdTextField, pwdUnderLine, pwdCheckLabel, pwdCheckTextField, pwdCheckUnderLine, signUpButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            
            emailUnderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            emailUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            pwdLabel.topAnchor.constraint(equalTo: emailUnderLine.bottomAnchor, constant: 30),
            pwdLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pwdTextField.topAnchor.constraint(equalTo: pwdLabel.bottomAnchor, constant: 5),
            pwdTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pwdUnderLine.topAnchor.constraint(equalTo: pwdTextField.bottomAnchor),
            pwdUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            pwdUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            pwdCheckLabel.topAnchor.constraint(equalTo: pwdUnderLine.bottomAnchor, constant: 30),
            pwdCheckLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdCheckLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pwdCheckTextField.topAnchor.constraint(equalTo: pwdCheckLabel.bottomAnchor, constant: 5),
            pwdCheckTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdCheckTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pwdCheckUnderLine.topAnchor.constraint(equalTo: pwdCheckTextField.bottomAnchor),
            pwdCheckUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pwdCheckUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            pwdCheckUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            signUpButton.topAnchor.constraint(equalTo: pwdCheckUnderLine.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ].forEach { $0.isActive = true}
    }
    
    
}

//MARK: - Keyboard Config
extension SignUpViewController {
    
    func keyboardConfig() {
        keyboard
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 {
                    self.view.frame.size.height -= self.keyboardHeight
                } else {
                    self.view.frame.size.height += self.keyboardHeight
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("show")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        self.keyboardHeight = keyboardSize.height
       // move the root view up by the distance of keyboard height
        self.keyboard.accept(true)
        
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         print("hide")
         guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
             // if keyboard size is not available for some reason, dont do anything
             return
         }
       // move back the root view origin to zero
         self.keyboardHeight = keyboardSize.height
         self.keyboard.accept(false)
     }
}
