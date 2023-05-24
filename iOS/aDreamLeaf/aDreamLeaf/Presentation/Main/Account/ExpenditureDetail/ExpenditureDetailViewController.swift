//
//  ExpenditureDetailViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift
import RxCocoa

class ExpenditureDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ExpenditureDetailViewModel
    
    private let titleLabel = UILabel()
    
    private let accountIdTitleLabel =  UILabel()
    private let accountIdLabel =  UILabel()
    
    private let priceTitleLabel =  UILabel()
    private let priceLabel =  UILabel()
    
    private let dateTitleLabel =  UILabel()
    private let dateLabel =  UILabel()
    
    private let bodyTitleLabel =  UILabel()
    private let bodyLabel =  UILabel()
    
    private let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
    private let editButton = UIButton()
    
    
    init(data: Expenditure) {
        viewModel = ExpenditureDetailViewModel(data: data)
        
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
        
        viewModel.data
            .map { String($0.accountId)}
            .bind(to: accountIdLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { $0.restaurant}
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { String($0.price)}
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { $0.date }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { String($0.body)}
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem?.tintColor = .red
    
        titleLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        [
            accountIdTitleLabel,
            priceTitleLabel,
            dateTitleLabel,
            bodyTitleLabel,
        ].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textAlignment = .left
        }
     
        accountIdTitleLabel.text = "지출번호"
        priceTitleLabel.text = "지출액"
        dateTitleLabel.text = "날짜"
        bodyTitleLabel.text = "항목"
        
        [
            accountIdLabel,
            priceLabel,
            dateLabel,
            bodyLabel,
        ].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.textAlignment = .right
            $0.textColor = .gray
        }
        
        editButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        editButton.setTitle("수정하기", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        editButton.setTitleColor(.black, for: .normal)
        editButton.layer.cornerRadius = 10
        
    }
    
    private func layout() {
        [
            titleLabel,
            accountIdTitleLabel,
            priceTitleLabel,
            dateTitleLabel,
            bodyTitleLabel,
            accountIdLabel,
            priceLabel,
            dateLabel,
            bodyLabel,
            editButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            accountIdTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            accountIdTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            accountIdLabel.topAnchor.constraint(equalTo: accountIdTitleLabel.topAnchor),
            accountIdLabel.leadingAnchor.constraint(equalTo: accountIdTitleLabel.trailingAnchor),
            accountIdLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceTitleLabel.topAnchor.constraint(equalTo: accountIdTitleLabel.bottomAnchor, constant: 10),
            priceTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceTitleLabel.trailingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 10),
            dateTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateTitleLabel.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            bodyTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 10),
            bodyTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bodyLabel.topAnchor.constraint(equalTo: bodyTitleLabel.topAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: bodyTitleLabel.trailingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            editButton.topAnchor.constraint(equalTo: bodyTitleLabel.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        ].forEach { $0.isActive = true }
    }
}
