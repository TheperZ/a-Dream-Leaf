//
//  AccountViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import MonthYearPicker
import SnapKit

class AccountViewController: UIChartViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AccountViewModel

    private var cover: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let cover = UIVisualEffectView(effect: blurEffect)
        return cover
    }()
    
    private let coverStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let coverMessageTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.text = "로그인이 필요한 기능입니다!\n로그인을 해주세요!"
        textView.font = .systemFont(ofSize: 15, weight: .semibold)
        textView.textColor = .darkGray
        textView.textAlignment = .center
        return textView
    }()
    
    private let gotoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "subColor2")
        button.setTitle("로그인하러 가기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: nil, action: nil)
    
    private let scrollView = UIScrollView()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가계부"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let datePicker: MonthYearPickerView = {
        let picker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        picker.addTarget(nil, action: #selector(dateChanged(_:)), for: .valueChanged)
        picker.locale = Locale(identifier: "ko-KR")
        picker.date = Date.getNowKorDate() ?? Date.now
        picker.maximumDate = Date.getNowKorDate()
        return picker
    }()
    
    private let divider = UIView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpenditureCell.self, forCellReuseIdentifier: K.TableViewCellID.ExpenditureCell)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "subColor2")
        button.setTitle("지출내역 추가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let emptyWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "해당 기간의 지출 내역이 없습니다!"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: UIChartViewModel())
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "tree"), tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        bindViewModel()
        uiEvent()
        layout()
        
    }
    
    private func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { [weak self] _ in self?.datePicker.date ?? .now }
            .asDriver(onErrorJustReturn: .now)
        
        let dateChange = selectedDate.asDriver(onErrorJustReturn: .now)
        
        let input = AccountViewModel.Input(trigger: Driver.merge(viewWillAppear, dateChange),
                                           select: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.tranform(input: input)
        
        output.login
            .drive(onNext: { login in
                if !login {
                    self.cover.isHidden = false
                    self.navigationItem.rightBarButtonItem = nil
                    self.emptyWarningLabel.isHidden = true
                } else {
                    self.cover.isHidden = true
                    self.navigationItem.rightBarButtonItem = self.settingButton
                }
            })
            .disposed(by: disposeBag)
        
        output.expenditures
            .drive(tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ExpenditureCell, for: indexPath) as! ExpenditureCell
                
                cell.setUp(viewModel: ExpenditureCellViewModel(expenditure: element))
                
                return cell
            }
            .disposed(by: disposeBag)
        
        output.expenditures
            .withLatestFrom(output.login) { ($0, $1) }
            .map { $0.count == 0 && $1 ? false : true}
            .drive(emptyWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.selectedExpenditure
            .drive(onNext: { expenditure in
                self.navigationController?.pushViewController(ExpenditureDetailViewController(viewModel: ExpenditureDetailViewModel(data: expenditure)), animated: true)
            })
            .disposed(by: disposeBag)
            
    }
    
    private func uiEvent() {
        settingButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(AccountSettingViewController(viewModel: AccountSettingViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(NewPaymentViewController(viewModel: NewPaymentViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        gotoLoginButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                let vc = UINavigationController(rootViewController: LoginViewController(viewModel: LoginViewModel()))
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
        
        hideMoreButton()
    
    }
    
    private func layout() {
        
        [scrollView, cover, emptyWarningLabel].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(topStackView)
        
        [titleLabel, datePicker, accountSummaryContainer,divider, tableView, addButton].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        cover.contentView.addSubview(coverStackView)
        
        [coverMessageTextView, gotoLoginButton].forEach {
            coverStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-60)
        }
        
        datePicker.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
        
        tableView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        cover.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
        
        coverStackView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.centerX.centerY.equalTo(cover)
        }
        
        coverMessageTextView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        gotoLoginButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        emptyWarningLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(tableView)
        }
    }
}

extension AccountViewController {
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        selectedDate.onNext(picker.date)
    }
}
