//
//  AccountViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import Charts
import MonthYearPicker

class AccountViewController: UIChartViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AccountViewModel
    
    private let titleLabel = UILabel()
    private let datePicker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
    
    private let divider = UIView()
    
    private let tableView = UITableView()
    
    private let addButton = UIButton()
    
    override init() {
        viewModel = AccountViewModel()
        super.init()
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "tree"), tag: 1)
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
        viewModel.list
            .bind(to: tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ExpenditureCell, for: indexPath) as! ExpenditureCell
                
                cell.setUp(with: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(NewPaymentViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .black
        
        titleLabel.text = "가계부"
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        chartSetting()
        hideMoreButton()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        
        divider.backgroundColor = .gray
        
        addButton.backgroundColor = UIColor(named: "subColor2")
        addButton.setTitle("지출내역 추가", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        
        tableView.register(ExpenditureCell.self, forCellReuseIdentifier: K.TableViewCellID.ExpenditureCell)
        tableView.backgroundColor = .white
        
    }
    
    private func layout() {
        [titleLabel, datePicker, accountSummaryContainer,divider, tableView, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 70),
            
            accountSummaryContainer.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            accountSummaryContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            accountSummaryContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            divider.topAnchor.constraint(equalTo: accountSummaryContainer.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            
            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ].forEach { $0.isActive = true }
    }
}
