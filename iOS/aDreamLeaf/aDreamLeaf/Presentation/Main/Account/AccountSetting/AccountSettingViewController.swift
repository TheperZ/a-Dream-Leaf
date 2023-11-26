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
        return button
    }()
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "지출 내역 추가 알림 받기"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
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
        [titleLabel, contentView, alarmLabel, alarmSwitch, loadingView].forEach {
            view.addSubview($0)
        }
        
        [budgetLabel, budgetTextField, underLine, wonLabel, budgetButton].forEach {
            contentView.addSubview($0)
        }
        
        loadingView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(320)
            $0.centerX.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        budgetLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.equalTo(titleLabel).offset(15)
            $0.trailing.equalTo(titleLabel).offset(-15)
        }
        
        budgetTextField.snp.makeConstraints {
            $0.top.equalTo(budgetLabel.snp.bottom).offset(10)
            $0.leading.equalTo(budgetLabel)
            $0.trailing.equalTo(wonLabel.snp.leading)
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(budgetTextField.snp.bottom)
            $0.leading.trailing.equalTo(budgetTextField)
            $0.height.equalTo(0.5)
        }
        
        wonLabel.snp.makeConstraints {
            $0.centerY.equalTo(budgetTextField)
            $0.trailing.equalTo(budgetButton.snp.leading).offset(-15)
            $0.width.equalTo(20)
        }
        
        budgetButton.snp.makeConstraints {
            $0.centerY.equalTo(wonLabel)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
            $0.trailing.bottom.equalTo(contentView).offset(-15)
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel).offset(5)
            $0.trailing.equalTo(alarmSwitch.snp.leading)
        }
        
        alarmSwitch.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.trailing.equalTo(titleLabel).offset(-10)
            $0.centerY.equalTo(alarmLabel)
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

