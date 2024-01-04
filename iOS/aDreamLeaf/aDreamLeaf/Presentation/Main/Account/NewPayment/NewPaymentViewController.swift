//
//  NewPaymentViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NewPaymentViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: NewPaymentViewModel
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let storeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let costStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지출내역 추가"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.maximumDate = Date()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        return picker
    }()
    
    private let divider1 = UIView()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "가게명"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let storeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "가게명을 입력해주세요."
        return textField
    }()
    
    private let divider2 = UIView()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "항목"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "내용을 입력해주세요."
        return textField
    }()
    
    private let divider3 = UIView()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "지출 비용"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let costTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "금액을 입력해주세요."
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    init(viewModel: NewPaymentViewModel) {
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
        
        let input = NewPaymentViewModel.Input(trigger: saveButton.rx.tap.asDriver(),
                                              date: datePicker.rx.date.asDriver(),
                                              store: storeNameTextField.rx.text.orEmpty.asDriver(),
                                              content: contentTextField.rx.text.orEmpty.asDriver(),
                                              cost: costTextField.rx.text.orEmpty.map { Int($0) ?? 0 }.asDriver(onErrorJustReturn: 0))
        
        let output = viewModel.transform(input: input)
        
        if let editData = output.editData {
            datePicker.date = Date.stringToDate(str: editData.date) ?? .now
            storeNameTextField.text = editData.restaurant
            contentTextField.text = editData.body
            costTextField.text = "\(editData.price)"
        }
        
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
            .drive(onNext: { result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: output.editData == nil ? "가계부에 추가되었습니다." : "정상적으로 수정되었습니다." , preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                } else {
                    self.loadingView.stopAnimating()
                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        costTextField.delegate = self
        
        [dateLabel, contentLabel, costLabel, storeNameLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textColor = .black
        }
        
        [contentTextField, costTextField, storeNameTextField].forEach {
            $0.textColor = .gray
            $0.textAlignment = .right
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        [divider1, divider2, divider3].forEach {
            $0.backgroundColor = .white
        }
        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func layout() {
        
        [loadingView, topStackView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, contentView].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [inputStackView, divider1, divider2, divider3].forEach {
            contentView.addSubview($0)
        }
        
        
        [dateStackView, storeStackView, contentStackView, costStackView].forEach {
            inputStackView.addArrangedSubview($0)
        }
        
        [dateLabel, datePicker].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        [storeNameLabel, storeNameTextField].forEach {
            storeStackView.addArrangedSubview($0)
        }
        
        [contentLabel, contentTextField].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [costLabel, costTextField].forEach {
            costStackView.addArrangedSubview($0)
        }
        
        
        loadingView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        datePicker.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        divider1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.top.equalTo(storeStackView)
        }
        
        divider2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.top.equalTo(contentStackView)
        }
        
        divider3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.top.equalTo(costStackView)
        }
        
    }
}

extension NewPaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

