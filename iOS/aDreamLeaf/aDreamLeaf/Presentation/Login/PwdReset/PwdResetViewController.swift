//
//  PwdResetViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/16.
//

import Foundation
import RxSwift
import RxCocoa

class PwdResetViewController: UIViewController, LoadingViewController {
    var disposeBag = DisposeBag()
    var loadingView = UIActivityIndicatorView(style: .medium)
    private var viewModel: PwdResetViewModel!
    private let titleLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailUnderLine = UIView()
    
    private let resetButton = UIButton()
    
    init() {
        viewModel = PwdResetViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLoadingView(viewModel: viewModel)
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.resetBtnTap)
            .disposed(by: disposeBag)
        
        viewModel.resetResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.success {
                    let alert = UIAlertController(title: "성공", message: "재설정을 위한 링크를 보냈습니다.\n이메일을 확인해주세요!", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                } else {
                    
                    let alert = UIAlertController(title: "실패", message: $0.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.viewModel.loading.onNext(false)
                    }
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
        
        titleLabel.text = "비밀번호 재설정"
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
        emailTextField.textContentType = .oneTimeCode
        
        emailUnderLine.backgroundColor = .lightGray
        
        resetButton.backgroundColor = UIColor(named: "mainColor")
        resetButton.setTitle("재설정 메일 보내기", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        
        [titleLabel, emailLabel, emailTextField, emailUnderLine, resetButton, loadingView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            emailUnderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailUnderLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emailUnderLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            emailUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            resetButton.topAnchor.constraint(equalTo: emailUnderLine.bottomAnchor, constant: 30),
            resetButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 45),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ].forEach { $0.isActive = true}
    }
    
}
