//
//  SearchViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder =
        NSAttributedString(string: "가게명, 행정구역, 주소 등을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let searchButtonConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        let searchButtonImg = UIImage(systemName: "magnifyingglass", withConfiguration: searchButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setImage(searchButtonImg, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let checkBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        return stackView
    }()
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let cardButton: UIButton = {
        let button = UIButton()
        button.setTitle("아동급식카드 가맹점", for: .normal)
        button.setImage(UIImage(systemName: "rectangle"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let goodButton: UIButton = {
        let button = UIButton()
        button.setTitle("선한영향력 가게", for: .normal)
        button.setImage(UIImage(systemName: "rectangle"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        return button
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(SearchCell.self, forCellReuseIdentifier: K.TableViewCellID.SearchCell)
        return tableView
    }()
    
    private let searchListEmptyWarnLabel: UILabel = {
        let label = UILabel()
        label.text = "검색된 음식점이 없습니다 🥲"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
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
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in ()}.asDriver(onErrorJustReturn: ())
        
        let input = SearchViewModel.Input(keyword: searchTextField.rx.text.orEmpty.asDriver(),
                                          trigger: Driver.merge(viewWillAppear, searchButton.rx.tap.asDriver()),
                                          allTrigger: allButton.rx.tap.asDriver(),
                                          cardTrigger: cardButton.rx.tap.asDriver(),
                                          goodTrigger: goodButton.rx.tap.asDriver(),
                                          select: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.tranform(input: input)
        
        output.stores
            .drive(tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.SearchCell, for: indexPath) as! SearchCell
                
                cell.setUp(with: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        
        output.mode
            .drive(onNext: {[weak self] mode in
                guard let self = self else { return }
                if mode == 0 { // 선한 영향력
                    self.allButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                    self.cardButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                    self.goodButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                } else if mode == 1 { // 아동 급식카드
                    self.allButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                    self.cardButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                    self.goodButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                } else if mode == 2 { // 전체
                    self.allButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                    self.cardButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                    self.goodButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        output.stores
            .map { $0.count != 0 }
            .asObservable()
            .bind(to: searchListEmptyWarnLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.selectedStore
            .drive(onNext: { [weak self] store in
                self?.navigationController?.pushViewController(StoreDetailViewController(viewModel: StoreDetailViewModel(storeId: store.storeId)), animated: true)
            })
            .disposed(by: disposeBag)

        
    }    
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [searchTextField, searchButton, underLine, tableView, checkBoxView, searchListEmptyWarnLabel].forEach {
            view.addSubview($0)
        }
        
        checkBoxView.addSubview(buttonStackView)
        
        [ allButton, goodButton, cardButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view).offset(20)
            $0.trailing.equalTo(searchButton.snp.leading)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(40)
            $0.height.equalTo(25)
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(0.2)
        }
        
        checkBoxView.snp.makeConstraints {
            $0.top.equalTo(underLine.snp.bottom).offset(20)
            $0.leading.equalTo(searchTextField)
            $0.trailing.equalTo(searchButton)
            $0.height.equalTo(30)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(checkBoxView)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(checkBoxView.snp.bottom).offset(10)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchListEmptyWarnLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(tableView)
        }
    
    }
}
