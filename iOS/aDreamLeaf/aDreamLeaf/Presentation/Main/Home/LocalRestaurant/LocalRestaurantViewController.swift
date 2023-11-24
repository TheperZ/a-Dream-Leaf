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
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
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
    
    private let nearListEmptyWarnLabel: UILabel = {
        let label = UILabel()
        label.text = "검색된 음식점이 없습니다 🥲"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    
    init(viewModel: LocalRestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in ()}.asDriver(onErrorJustReturn: ())
        
        let input = LocalRestaurantViewModel.Input(trigger: viewWillAppear,
                                                   allTrigger: allButton.rx.tap.asDriver(),
                                                   cardTrigger: cardButton.rx.tap.asDriver(),
                                                   goodTrigger: goodButton.rx.tap.asDriver(),
                                                   select: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.stores
            .drive(tableView.rx.items) { tv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.SearchCell, for: indexPath) as! SearchCell
                
                cell.setUp(with: element)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        output.stores
            .map { $0.count != 0 }
            .asObservable()
            .bind(to: nearListEmptyWarnLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.address
            .drive(addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.selectedStore
            .drive(onNext: { [weak self] store in
                self?.navigationController?.pushViewController(StoreDetailViewController(viewModel: StoreDetailViewModel(storeId: store.storeId)), animated: true)
            })
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

    }
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func layout() {
        
        [imageView, addressLabel, tableView, buttonStackView, checkBoxView, nearListEmptyWarnLabel].forEach {
            view.addSubview($0)
        }
        
        checkBoxView.addSubview(buttonStackView)
        
        [allButton, goodButton, cardButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view).offset(30)
            $0.height.width.equalTo(25)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalTo(view).offset(-30)
        }
        
        checkBoxView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.equalTo(imageView)
            $0.trailing.equalTo(addressLabel)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(checkBoxView)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(15)
            $0.leading.equalTo(view).offset(10)
            $0.trailing.equalTo(view).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        nearListEmptyWarnLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(tableView)
        }
    }
    
}
