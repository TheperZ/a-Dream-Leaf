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
    
    private var blurEffect: UIBlurEffect!
    private var cover: UIVisualEffectView!
    private let coverMessageTextView = UITextView()
    
    private let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: nil, action: nil)
    
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
        
        attribute()
        coverSetting()
        bind()
        layout()
        
    }
    
    private func coverSetting() {
        blurEffect = UIBlurEffect(style: .regular)
        cover = UIVisualEffectView(effect: blurEffect)
        
        coverMessageTextView.backgroundColor = .clear
        coverMessageTextView.text = "로그인이 필요한 기능입니다!\n로그인을 해주세요!"
        coverMessageTextView.font = .systemFont(ofSize: 15, weight: .semibold)
        coverMessageTextView.textColor = .darkGray
        coverMessageTextView.textAlignment = .center
    }
    
    private func bind() {
        
        UserManager.getInstance()
            .subscribe(onNext: { user in
                if user == nil {
                    self.cover.isHidden = false
                    self.navigationItem.rightBarButtonItem = nil
                } else {
                    self.cover.isHidden = true
                    self.navigationItem.rightBarButtonItem = self.settingButton
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.list
            .bind(to: tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ExpenditureCell, for: indexPath) as! ExpenditureCell
                
                cell.setUp(with: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(AccountSettingViewController(), animated: true)
            })
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
        
        navigationItem.rightBarButtonItem = settingButton
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
        [titleLabel, datePicker, accountSummaryContainer,divider, tableView, addButton, cover].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cover.contentView.addSubview(coverMessageTextView)
        coverMessageTextView.translatesAutoresizingMaskIntoConstraints = false
        
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
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            cover.topAnchor.constraint(equalTo: view.topAnchor),
            cover.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            coverMessageTextView.heightAnchor.constraint(equalToConstant: 50),
            coverMessageTextView.widthAnchor.constraint(equalToConstant: 200),
            coverMessageTextView.centerXAnchor.constraint(equalTo: cover.contentView.centerXAnchor),
            coverMessageTextView.centerYAnchor.constraint(equalTo: cover.contentView.centerYAnchor),
        ].forEach { $0.isActive = true }
    }
}
