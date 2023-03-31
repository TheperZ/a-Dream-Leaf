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
    
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    private let underLine = UIView()
    private let checkBoxView = UIView()
    private let buttonStackView = UIStackView()
    private let allButton = UIButton()
    private let cardButton = UIButton()
    private let goodButton = UIButton()
    private let tableView = UITableView()
    
    init() {
        viewModel = SearchViewModel()
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: K.TableViewCellID.SearchCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        viewModel.list
            .bind(to: tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.SearchCell, for: indexPath) as! SearchCell
                
                cell.setUp(with: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        
    }    
    
    private func attribute() {
        view.backgroundColor = .white
        
        searchTextField.textColor = .black
        searchTextField.font = .systemFont(ofSize: 16, weight: .regular)
        searchTextField.attributedPlaceholder =
        NSAttributedString(string: "가게명, 행정구역, 주소 등을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        let searchButtonConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        let searchButtonImg = UIImage(systemName: "magnifyingglass", withConfiguration: searchButtonConfig)?.withRenderingMode(.alwaysTemplate)
        searchButton.setImage(searchButtonImg, for: .normal)
        searchButton.tintColor = .black
        
        underLine.backgroundColor = .lightGray
        
        checkBoxView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        checkBoxView.layer.cornerRadius = 5
        
        buttonStackView.spacing = 15
        
        
        allButton.setTitle("전체", for: .normal)
        allButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        allButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        allButton.setTitleColor(.black, for: .normal)
        allButton.tintColor = .black
        allButton.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        
        cardButton.setTitle("아동급식카드 가맹점", for: .normal)
        cardButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        cardButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        cardButton.setTitleColor(.black, for: .normal)
        cardButton.tintColor = .black
        cardButton.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        
        goodButton.setTitle("선한영향력 가게", for: .normal)
        goodButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        goodButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        goodButton.setTitleColor(.black, for: .normal)
        goodButton.tintColor = .black
        goodButton.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    private func layout() {
        [searchTextField, searchButton, underLine, tableView, checkBoxView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        checkBoxView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [ allButton, cardButton, goodButton].forEach {
            buttonStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            
            underLine.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 15),
            underLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 0.2),
            
            checkBoxView.heightAnchor.constraint(equalToConstant: 30),
            checkBoxView.topAnchor.constraint(equalTo: underLine.bottomAnchor, constant: 20),
            checkBoxView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            checkBoxView.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            
            buttonStackView.centerXAnchor.constraint(equalTo: checkBoxView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: checkBoxView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: checkBoxView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ].forEach { $0.isActive = true }
    }
}
