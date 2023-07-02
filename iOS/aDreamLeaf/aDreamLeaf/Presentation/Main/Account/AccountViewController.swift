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
    private let coverStackView = UIStackView()
    private let coverMessageTextView = UITextView()
    private let gotoLoginButton = UIButton()
    
    private let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: nil, action: nil)
    
    private let titleLabel = UILabel()
    private let datePicker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
    
    private let divider = UIView()
    
    private let tableView = UITableView()
    
    private let addButton = UIButton()
    
    private let emptyWarningLabel = UILabel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refreshRequest.onNext(Void())
    }
    
    private func coverSetting() {
        blurEffect = UIBlurEffect(style: .regular)
        cover = UIVisualEffectView(effect: blurEffect)
        
        coverStackView.axis = .vertical
        coverStackView.spacing = 10
        
        coverMessageTextView.isScrollEnabled = false
        coverMessageTextView.isSelectable = false
        coverMessageTextView.isEditable = false
        coverMessageTextView.backgroundColor = .clear
        coverMessageTextView.text = "로그인이 필요한 기능입니다!\n로그인을 해주세요!"
        coverMessageTextView.font = .systemFont(ofSize: 15, weight: .semibold)
        coverMessageTextView.textColor = .darkGray
        coverMessageTextView.textAlignment = .center
        
        gotoLoginButton.backgroundColor = UIColor(named: "subColor2")
        gotoLoginButton.setTitle("로그인하러 가기", for: .normal)
        gotoLoginButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        gotoLoginButton.setTitleColor(.white, for: .normal)
        gotoLoginButton.layer.cornerRadius = 10
    }
    
    private func bind() {
        
        UserManager.getInstance()
            .subscribe(onNext: { user in
                if user == nil {
                    self.cover.isHidden = false
                    self.navigationItem.rightBarButtonItem = nil
                    self.emptyWarningLabel.isHidden = true
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
        
        viewModel.list
            .map { $0.count == 0 ? false : true}
            .bind(to: emptyWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.list) { return ($0, $1)}
            .subscribe(onNext: { indexPath, list in
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
                self.navigationController?.pushViewController(ExpenditureDetailViewController(data: list[indexPath.row]), animated: true)
            })
            .disposed(by: disposeBag)
        
        gotoLoginButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let vc = UINavigationController(rootViewController: LoginViewController())
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
            
    }
    
    private func attribute() {
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = settingButton
        navigationController?.navigationBar.tintColor = .black
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        titleLabel.text = "가계부"
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        chartSetting()
        hideMoreButton()
        
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.date = Date.getNowKorDate() ?? Date.now
        datePicker.maximumDate = Date.getNowKorDate()
        print("date", Date.getNowKorDateString())
        
        addButton.backgroundColor = UIColor(named: "subColor2")
        addButton.setTitle("지출내역 추가", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        
        tableView.register(ExpenditureCell.self, forCellReuseIdentifier: K.TableViewCellID.ExpenditureCell)
        tableView.backgroundColor = .white
        
        emptyWarningLabel.text = "해당 기간의 지출 내역이 없습니다!"
        emptyWarningLabel.font = .systemFont(ofSize: 16, weight: .bold)
        emptyWarningLabel.textColor = .black
        emptyWarningLabel.textAlignment = .center
        emptyWarningLabel.isHidden = true
        
    }
    
    private func layout() {
        [titleLabel, datePicker, accountSummaryContainer,divider, tableView, addButton, cover, emptyWarningLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cover.contentView.addSubview(coverStackView)
        coverStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [coverMessageTextView, gotoLoginButton].forEach {
            coverStackView.addArrangedSubview($0)
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
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            cover.topAnchor.constraint(equalTo: view.topAnchor),
            cover.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            coverStackView.widthAnchor.constraint(equalToConstant: 200),
            coverStackView.centerXAnchor.constraint(equalTo: cover.contentView.centerXAnchor),
            coverStackView.centerYAnchor.constraint(equalTo: cover.contentView.centerYAnchor),
            
            coverMessageTextView.heightAnchor.constraint(equalToConstant: 50),

            gotoLoginButton.heightAnchor.constraint(equalToConstant: 30),
            gotoLoginButton.widthAnchor.constraint(equalToConstant: 150),
            
            emptyWarningLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 80),
            emptyWarningLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            emptyWarningLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        ].forEach { $0.isActive = true }
    }
}

extension AccountViewController {
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        viewModel.yearMonth.onNext(picker.date)
        chartViewModel.date.onNext(Date.dateToString(with: picker.date, format: "yyyy-MM"))
     }
}
