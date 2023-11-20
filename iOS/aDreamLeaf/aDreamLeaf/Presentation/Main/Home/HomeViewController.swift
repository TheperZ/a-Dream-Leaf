//
//  HomeViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class HomeViewController: UIChartViewController {
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꿈나무 한입"
        label.font = UIFont(name: "LINESeedSansKR-Bold", size: 28)
        label.textColor = .black
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        let profileButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let profileButtonImg = UIImage(systemName: "person.circle", withConfiguration: profileButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setImage(profileButtonImg, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let nearRestSummaryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nearRestTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주변 음식점"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let nearRestMoreButon: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        return button
    }()
    
    private let nearRestSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리동네 꿈나무 식당을 소개합니다 :)"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let nearRestEmptyAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "주변의 음식점을 찾을 수 없습니다 🥲"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10
        return label
    }()
    
    private let nearRestCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 110)
        return layout
    }()
    
    private lazy var nearRestCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: nearRestCollectionViewLayout)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 15)
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: K.CollectionViewCellID.RestaurantCell)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        return collectionView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let goodInfoImageView: UIImageView = {
        let imageView = UIImageView()
        let goodConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let goodImg = UIImage(systemName: "leaf", withConfiguration: goodConfig)?.withRenderingMode(.alwaysTemplate)
        imageView.image = goodImg
        imageView.tintColor = UIColor(named: "subColor")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let goodInfoTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "선한 영향력 /"
        textLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textLabel.textColor = .gray
        return textLabel
    }()
    
    private let cardInfoImageView: UIImageView = {
        let imageView = UIImageView()
        let cardConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let cardImg = UIImage(systemName: "creditcard", withConfiguration: cardConfig)?.withRenderingMode(.alwaysTemplate)
        imageView.image = cardImg
        imageView.tintColor = UIColor(named: "subColor")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cardInfoTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "꿈나무 카드"
        textLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textLabel.textColor = .gray
        return textLabel
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
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
        viewModel.nearStores
            .bind(to: nearRestCollectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCellID.RestaurantCell, for: indexPath) as! RestaurantCell
                cell.setUp(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(UserManager.getInstance())
            .subscribe(onNext: { user in
                if user != nil {
                    let vc = MyPageViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    let vc = UINavigationController(rootViewController: LoginViewController())
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        accountMoreButtonTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{
                self.tabBarController?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
        
        nearRestMoreButon.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.pushViewController(LocalRestaurantViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        nearRestCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.nearStores) { return ($0, $1)}
            .subscribe(onNext: { indexPath, list in
                self.nearRestCollectionView.cellForItem(at: indexPath)?.isSelected = false
                self.navigationController?.pushViewController(StoreDetailViewController(storeId: (list[indexPath.row]).storeId), animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.nearStores
            .observe(on: MainScheduler.instance)
            .map { $0.count != 0 }
            .bind(to: nearRestEmptyAlertLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: -10, right: 0)
        
        chartSetting()
    }
    
    private func layout() {
        [titleLabel, profileButton, accountSummaryContainer, nearRestSummaryContainer, infoStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
        [nearRestTitleLabel, nearRestMoreButon, nearRestSubTitleLabel, nearRestCollectionView, nearRestEmptyAlertLabel].forEach {
            nearRestSummaryContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [goodInfoImageView, goodInfoTextLabel, cardInfoImageView, cardInfoTextLabel].forEach {
            infoStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            profileButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            accountSummaryContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            accountSummaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountSummaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nearRestSummaryContainer.topAnchor.constraint(equalTo: accountSummaryContainer.bottomAnchor, constant: 40),
            nearRestSummaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nearRestSummaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nearRestSummaryContainer.heightAnchor.constraint(equalToConstant: 200),
            
            nearRestTitleLabel.topAnchor.constraint(equalTo: nearRestSummaryContainer.topAnchor, constant: 20),
            nearRestTitleLabel.leadingAnchor.constraint(equalTo: nearRestSummaryContainer.leadingAnchor, constant: 30),
            
            nearRestMoreButon.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor, constant: -15),
            nearRestMoreButon.centerYAnchor.constraint(equalTo: nearRestTitleLabel.centerYAnchor),
            nearRestMoreButon.widthAnchor.constraint(equalToConstant: 60),
            
            nearRestSubTitleLabel.topAnchor.constraint(equalTo: nearRestTitleLabel.bottomAnchor,constant: 10),
            nearRestSubTitleLabel.leadingAnchor.constraint(equalTo: nearRestTitleLabel.leadingAnchor),
            
            nearRestCollectionView.topAnchor.constraint(equalTo: nearRestSubTitleLabel.bottomAnchor, constant: 15),
            nearRestCollectionView.leadingAnchor.constraint(equalTo: nearRestSummaryContainer.leadingAnchor),
            nearRestCollectionView.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor),
            nearRestCollectionView.bottomAnchor.constraint(equalTo: nearRestSummaryContainer.bottomAnchor, constant: -10),
            
            nearRestEmptyAlertLabel.topAnchor.constraint(equalTo: nearRestCollectionView.topAnchor),
            nearRestEmptyAlertLabel.bottomAnchor.constraint(equalTo: nearRestCollectionView.bottomAnchor),
            nearRestEmptyAlertLabel.leadingAnchor.constraint(equalTo: nearRestCollectionView.leadingAnchor, constant: 20),
            nearRestEmptyAlertLabel.trailingAnchor.constraint(equalTo: nearRestCollectionView.trailingAnchor, constant: -20),
            
            infoStackView.topAnchor.constraint(equalTo: nearRestSummaryContainer.bottomAnchor, constant: 5),
            infoStackView.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor, constant: -15),
            
            
        ].forEach { $0.isActive = true}
    }
    
}
