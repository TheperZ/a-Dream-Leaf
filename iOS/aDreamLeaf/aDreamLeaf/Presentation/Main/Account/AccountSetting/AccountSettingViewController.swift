//
//  AccountSettingViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa

class AccountSettingViewController: UIViewController, LoadingViewController {
    var disposeBag = DisposeBag()
    
    var loadingView: UIActivityIndicatorView
    
    private let viewModel: AccountSettingViewModel
    
    private let titleLabel = UILabel()
    
    private let contentView = UIView()
    private let budgetLabel = UILabel()
    private let budgetTextField = UITextField()
    private let underLine = UIView()
    private let wonLabel = UILabel()
    private let budgetButton = UIButton()
    
    private let alarmLabel = UILabel()
    private let alarmSwitch = UISwitch()
    
    init() {
        viewModel = AccountSettingViewModel()
        loadingView = UIActivityIndicatorView(style: .medium)
        super.init(nibName: nil, bundle: nil)
        
        configLoadingView(viewModel: viewModel) // 로딩 화면을 위한 설정
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
        budgetButton.rx.tap
            .bind(to: viewModel.saveBtnTap)
            .disposed(by: disposeBag)
        
        budgetTextField.rx.text
            .orEmpty
            .map { Int($0) ?? -1 }
            .bind(to: viewModel.amount)
            .disposed(by: disposeBag)
        
        viewModel.budgetSettingResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: "예산이 정상적으로 저장되었습니다!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.alarmState
            .bind(to: alarmSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        alarmSwitch.rx
            .controlEvent(.valueChanged)
            .map { self.alarmSwitch.isOn }
            .bind(to: viewModel.alarmSwitchChanged)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        setActivityIndicatorViewAlpha(to: UIColor(white: 1, alpha: 0.3))
        
        titleLabel.text = "가계부 설정"
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        contentView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        budgetLabel.text = "이번 달 예산 설정"
        budgetLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        budgetLabel.textColor = .black
        
        budgetTextField.delegate = self
        budgetTextField.keyboardType = .decimalPad
        budgetTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        budgetTextField.textColor = .black
        budgetTextField.textAlignment = .right
        
        wonLabel.text = "원"
        wonLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        wonLabel.textColor = .black
        
        underLine.backgroundColor = .lightGray
        
        budgetButton.setTitle("저장", for: .normal)
        budgetButton.backgroundColor = UIColor(named: "subColor2")
        budgetButton.setTitleColor(.white, for: .normal)
        budgetButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        budgetButton.layer.cornerRadius = 5
        
        alarmLabel.text = "지출 내역 추가 알림 받기"
        alarmLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        alarmLabel.textColor = .black
        
    }
    
    private func layout() {
        [titleLabel, contentView, alarmLabel, alarmSwitch, loadingView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [budgetLabel, budgetTextField, underLine, wonLabel, budgetButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        [
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 320),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            budgetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            budgetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            budgetLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            budgetTextField.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 10),
            budgetTextField.trailingAnchor.constraint(equalTo: wonLabel.leadingAnchor),
            budgetTextField.leadingAnchor.constraint(equalTo: budgetLabel.leadingAnchor),
            
            underLine.topAnchor.constraint(equalTo: budgetTextField.bottomAnchor),
            underLine.leadingAnchor.constraint(equalTo: budgetTextField.leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: budgetTextField.trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            wonLabel.centerYAnchor.constraint(equalTo: budgetTextField.centerYAnchor),
            wonLabel.trailingAnchor.constraint(equalTo: budgetButton.leadingAnchor, constant: -15),
            wonLabel.widthAnchor.constraint(equalToConstant: 20),
            
            budgetButton.centerYAnchor.constraint(equalTo: wonLabel.centerYAnchor),
            budgetButton.widthAnchor.constraint(equalToConstant: 50),
            budgetButton.heightAnchor.constraint(equalToConstant: 30),
            budgetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            budgetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            alarmLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30),
            alarmLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 5),
            alarmLabel.trailingAnchor.constraint(equalTo: alarmSwitch.leadingAnchor),
            
            alarmSwitch.widthAnchor.constraint(equalToConstant: 40),
            alarmSwitch.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10),
            alarmSwitch.centerYAnchor.constraint(equalTo: alarmLabel.centerYAnchor),
            
        ].forEach { $0.isActive = true }
    }
}

extension AccountSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

