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
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
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
    }
    
    private func layout() {
        [searchTextField, searchButton, underLine, tableView].forEach {
            view.addSubview($0)
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
            
            tableView.topAnchor.constraint(equalTo: underLine.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ].forEach { $0.isActive = true }
    }
}
