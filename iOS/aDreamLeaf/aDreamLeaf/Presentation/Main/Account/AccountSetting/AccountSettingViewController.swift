//
//  AccountSettingViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class AccountSettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: AccountSettingViewModel
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let accountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let accountInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let alarmStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가계부 설정"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        return view
    }()
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 예산 설정"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let budgetTextField: UITextField = {
        let textField = UITextField()
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.textColor = .black
        textField.textAlignment = .right
        return textField
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let wonLabel: UILabel = {
        let label = UILabel()
        label.text = "원"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let budgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = UIColor(named: "subColor2")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 5
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "지출 내역 추가 알림 받기"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let alarmSwitch = UISwitch()
    
    init(viewModel: AccountSettingViewModel) {
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
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = AccountSettingViewModel.Input(trigger: viewWillAppear,
                                                  budget: budgetTextField.rx.text.orEmpty.map { Int($0) ?? 0 }.asDriver(onErrorJustReturn: 0),
                                                  budgetTrigger: budgetButton.rx.tap.asDriver(),
                                                  alarmTrigger: alarmSwitch.rx.controlEvent(.valueChanged).asDriver())
        
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
        

        output.alarm
            .drive(alarmSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        output.budgetResult
            .drive(onNext: { [weak self] result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: "예산이 정상적으로 저장되었습니다!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(cancel)
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(cancel)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        budgetTextField.delegate = self
    }
    
    private func layout() {
        [topStackView, contentView, alarmStackView, loadingView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, contentView, alarmStackView].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [accountStackView, underLine].forEach {
            contentView.addSubview($0)
        }
        
        [budgetLabel, accountInputStackView].forEach {
            accountStackView.addArrangedSubview($0)
        }
        
        [budgetTextField, wonLabel, budgetButton].forEach {
            accountInputStackView.addArrangedSubview($0)
        }
        
        [alarmLabel, alarmSwitch].forEach {
            alarmStackView.addArrangedSubview($0)
        }
        
        
        loadingView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        accountStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
        }
       
        budgetButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        
        underLine.snp.makeConstraints {
            $0.bottom.equalTo(budgetTextField)
            $0.leading.trailing.equalTo(budgetTextField)
            $0.height.equalTo(1)
        }
    }
}

extension AccountSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

