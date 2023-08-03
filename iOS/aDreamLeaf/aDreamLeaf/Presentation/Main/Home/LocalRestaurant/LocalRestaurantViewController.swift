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
    
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let imageView = UIImageView(image: UIImage(systemName: "location.fill"))
    private let addressLabel = UILabel()
    
    private let checkBoxView = UIView()
    private let buttonStackView = UIStackView()
    private let allButton = UIButton()
    private let cardButton = UIButton()
    private let goodButton = UIButton()
    
    private let tableView = UITableView()
    
    private let nearListEmptyWarnLabel = UILabel()
    
    
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
        
        loadingSetting()
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        viewModel.tableItem
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
        
        allButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.allButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                self.cardButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.goodButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.viewModel.allButtonTap.accept(Void())
            })
            .disposed(by: disposeBag)
        
        cardButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.cardButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                self.allButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.goodButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.viewModel.cardButtonTap.accept(Void())
            })
            .disposed(by: disposeBag)
        
        goodButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.goodButton.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                self.cardButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.allButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
                self.viewModel.goodButtonTap.accept(Void())
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.tableItem) { return ($0, $1)}
            .subscribe(onNext: { indexPath, list in
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
                self.navigationController?.pushViewController(StoreDetailViewController(storeId: (list[indexPath.row]).storeId), animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.tableItem
            .map { $0.count != 0 }
            .observe(on: MainScheduler.instance)
            .bind(to: nearListEmptyWarnLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        
        addressLabel.textColor = .black
        addressLabel.textAlignment = .left
        
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
        
        tableView.backgroundColor = .white
        
        nearListEmptyWarnLabel.text = "검색된 음식점이 없습니다 🥲"
        nearListEmptyWarnLabel.textColor = .black
        nearListEmptyWarnLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nearListEmptyWarnLabel.textAlignment = .center
    }
    
    private func layout() {
        
        [imageView, addressLabel, tableView, buttonStackView, checkBoxView, nearListEmptyWarnLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        checkBoxView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [allButton, goodButton, cardButton].forEach {
            buttonStackView.addArrangedSubview($0)
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
            
            checkBoxView.heightAnchor.constraint(equalToConstant: 30),
            checkBoxView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            checkBoxView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            checkBoxView.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor),
            
            buttonStackView.centerXAnchor.constraint(equalTo: checkBoxView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: checkBoxView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            nearListEmptyWarnLabel.topAnchor.constraint(equalTo: tableView.topAnchor),
            nearListEmptyWarnLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            nearListEmptyWarnLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            nearListEmptyWarnLabel.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ].forEach { $0.isActive = true}
    }
    
}

extension LocalRestaurantViewController {
    func loadingSetting() {
        
        loadingView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { loading in
                if loading {
                    self.loadingView.startAnimating()
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
