//
//  PwdResetViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/16.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class PwdResetViewController: UIViewController {
    var disposeBag = DisposeBag()
    var loadingView = UIActivityIndicatorView(style: .medium)
    private var viewModel: PwdResetViewModel!
    
    private let stackView: UIStackView = {
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재설정"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
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
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainColor")
        button.setTitle("재설정 메일 보내기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    init(viewModel: PwdResetViewModel) {
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
    
    private func bindViewModel() {
        
        let input = PwdResetViewModel.Input(email: emailTextField.rx.text.orEmpty.asDriver(),
                                            trigger: resetButton.rx.tap.asDriver())
        
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
                        let alert = UIAlertController(title: "성공", message: "재설정을 위한 링크를 보냈습니다.\n이메일을 확인해주세요!", preferredStyle: .alert)
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
        
        [stackView, loadingView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, emailStackView, resetButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [emailLabel, emailTextField, emailUnderLine].forEach {
            emailStackView.addArrangedSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(30)
            $0.trailing.equalTo(view).offset(-30)
            $0.centerX.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        emailUnderLine.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
    }
    
}
