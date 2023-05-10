//
//  LocalRestaurantViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/03.
//

import UIKit
import RxSwift
import RxCocoa

class LocalRestaurantViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: LocalRestaurantViewModel!
    
    private let imageView = UIImageView(image: UIImage(systemName: "location.fill"))
    private let addressLabel = UILabel()
    
    private let tableView = UITableView()
    
    init() {
        viewModel = LocalRestaurantViewModel()
        
        super.init(nibName: nil, bundle: nil)
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
        
        viewModel.address
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        addressLabel.textColor = .black
        addressLabel.textAlignment = .left
        
        tableView.backgroundColor = .white
    }
    
    private func layout() {
        
        [imageView, addressLabel, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            
            addressLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ].forEach { $0.isActive = true}
    }
    
}
