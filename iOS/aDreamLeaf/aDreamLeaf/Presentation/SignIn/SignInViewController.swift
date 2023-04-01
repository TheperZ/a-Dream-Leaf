//
//  SignInViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SignInViewModel
    
    let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let nameUnderLine = UIView()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailUnderLine = UIView()
    
    private let pwdLabel = UILabel()
    private let pwdTextField = UITextField()
    private let pwdUnderLine = UIView()
    
    private let pwdCheckLabel = UILabel()
    private let pwdCheckTextField = UITextField()
    private let pwdCheckUnderLine = UIView()
    
    private let signInButton = UIButton()
    
    init() {
        viewModel = SignInViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        self.navigationController?.navigationBar.tintColor = .black
        
        titleLabel.text = "회원가입"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        nameLabel.text = "이름"
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        nameTextField.textColor = .black
        nameTextField.font = .systemFont(ofSize: 20, weight: .regular)
        nameTextField.keyboardType = .emailAddress
        nameUnderLine.backgroundColor = .lightGray
        
        emailLabel.text = "이메일"
        emailLabel.textColor = .black
        emailLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        emailTextField.textColor = .black
        emailTextField.font = .systemFont(ofSize: 20, weight: .regular)
        emailTextField.keyboardType = .emailAddress
        emailUnderLine.backgroundColor = .lightGray
        
        pwdLabel.text = "비밀번호"
        pwdLabel.textColor = .black
        pwdLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        pwdTextField.textColor = .black
        pwdTextField.font = .systemFont(ofSize: 20, weight: .regular)
        pwdTextField.keyboardType = .emailAddress
        pwdUnderLine.backgroundColor = .lightGray
        
        pwdCheckLabel.text = "비밀번호 확인"
        pwdCheckLabel.textColor = .black
        pwdCheckLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        pwdCheckTextField.textColor = .black
        pwdCheckTextField.font = .systemFont(ofSize: 20, weight: .regular)
        pwdCheckTextField.keyboardType = .emailAddress
        pwdCheckUnderLine.backgroundColor = .lightGray
        
        signInButton.backgroundColor = UIColor(named: "mainColor")
        signInButton.setTitle("회원가입 하기", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, nameLabel, nameTextField, nameUnderLine, emailLabel, emailTextField, emailUnderLine, pwdLabel, pwdTextField, pwdUnderLine, pwdCheckLabel, pwdCheckTextField, pwdCheckUnderLine, signInButton].forEach {
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
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            nameUnderLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nameUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            emailLabel.topAnchor.constraint(equalTo: nameUnderLine.bottomAnchor, constant: 30),
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
            
            signInButton.topAnchor.constraint(equalTo: pwdCheckUnderLine.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ].forEach { $0.isActive = true}
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
             
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
       // move the root view up by the distance of keyboard height
        self.view.frame.size.height -= keyboardSize.height
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
             // if keyboard size is not available for some reason, dont do anything
             return
         }
       // move back the root view origin to zero
         self.view.frame.size.height += keyboardSize.height
     }
}
