//
//  NewPaymentViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import UIKit
import RxSwift
import RxCocoa

class NewPaymentViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: NewPaymentViewModel
    
    private let titleLabel = UILabel()
    
    private let contentView = UIView()
    
    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    private let divider1 = UIView()
    
    private let storeNameLabel = UILabel()
    private let storeNameTextField = UITextField()
    
    private let divider2 = UIView()
    
    private let contentLabel = UILabel()
    private let contentTextField = UITextField()
    
    private let divider3 = UIView()
    
    private let costLabel = UILabel()
    private let costTextField = UITextField()
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    init() {
        self.viewModel = NewPaymentViewModel()
        super.init(nibName: nil, bundle: nil)
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
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = "지출내역 추가"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.layer.cornerRadius = 10
        
        [dateLabel, contentLabel, costLabel, storeNameLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textColor = .black
        }
        
        dateLabel.text = "날짜"
        storeNameLabel.text = "가게명"
        contentLabel.text = "항목"
        costLabel.text = "지출 비용"
        
        [contentTextField, costTextField, storeNameTextField].forEach {
            $0.textColor = .gray
            $0.textAlignment = .right
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        storeNameTextField.placeholder = "가게명을 입력해주세요."
        contentTextField.placeholder = "내용을 입력해주세요."
        costTextField.placeholder = "금액을 입력해주세요."
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        [divider1, divider2, divider3].forEach {
            $0.backgroundColor = .white
        }
        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func layout() {
        
        [titleLabel, contentView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        [dateLabel, datePicker, divider1, storeNameLabel, storeNameTextField, divider2, contentLabel, contentTextField, divider3, costLabel, costTextField].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 330),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            contentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.widthAnchor.constraint(equalToConstant: 70),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            datePicker.heightAnchor.constraint(equalToConstant: 50),
            datePicker.widthAnchor.constraint(equalToConstant: 230),
            
            divider1.heightAnchor.constraint(equalToConstant: 0.5),
            divider1.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            storeNameLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 15),
            storeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            storeNameLabel.widthAnchor.constraint(equalToConstant: 70),
            storeNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            storeNameTextField.centerYAnchor.constraint(equalTo: storeNameLabel.centerYAnchor),
            storeNameTextField.leadingAnchor.constraint(equalTo: storeNameLabel.trailingAnchor),
            storeNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            divider2.heightAnchor.constraint(equalToConstant: 0.5),
            divider2.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 15),
            divider2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 15),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentLabel.widthAnchor.constraint(equalToConstant: 70),
            contentLabel.heightAnchor.constraint(equalToConstant: 20),
            
            contentTextField.centerYAnchor.constraint(equalTo: contentLabel.centerYAnchor),
            contentTextField.leadingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
            contentTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            divider3.heightAnchor.constraint(equalToConstant: 0.5),
            divider3.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15),
            divider3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            costLabel.topAnchor.constraint(equalTo: divider3.bottomAnchor, constant: 15),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            costLabel.widthAnchor.constraint(equalToConstant: 70),
            costLabel.heightAnchor.constraint(equalToConstant: 20),
            
            costTextField.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor),
            costTextField.leadingAnchor.constraint(equalTo: costLabel.trailingAnchor),
            costTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            costTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            
        ].forEach { $0.isActive = true }
    }
}
