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
    
    let titleLabel = UILabel()
    let profileButton = UIButton()
    
    private let nearRestSummaryContainer = UIView()
    private let nearRestTitleLabel = UILabel()
    private let nearRestMoreButon = UIButton()
    private let nearRestSubTitleLabel = UILabel()
    
    private let nearRestCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 110)
        return layout
    }()
    
    private lazy var nearRestCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: nearRestCollectionViewLayout)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 15)
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: K.CollectionViewCellID.RestaurantCell)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init() {
        viewModel = HomeViewModel()
        super.init()
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: -10, right: 0)
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
        viewModel.nearRests
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
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = "꿈나무 한입"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .black
        
        let profileButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let profileButtonImg = UIImage(systemName: "person.circle", withConfiguration: profileButtonConfig)?.withRenderingMode(.alwaysTemplate)
        profileButton.setImage(profileButtonImg, for: .normal)
        profileButton.tintColor = .black
        
        chartSetting()
        
        nearRestSummaryContainer.backgroundColor = .white
        nearRestSummaryContainer.layer.cornerRadius = 10
        
        nearRestTitleLabel.text = "주변 음식점"
        nearRestTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nearRestTitleLabel.textColor = .black
        
        nearRestMoreButon.setTitle("더보기", for: .normal)
        nearRestMoreButon.setTitleColor(.gray, for: .normal)
        nearRestMoreButon.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        
        nearRestSubTitleLabel.text = "우리동네 꿈나무 식당을 소개합니다 :)"
        nearRestSubTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        nearRestSubTitleLabel.textColor = .black
        
        nearRestCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
    }
    
    private func layout() {
        [titleLabel, profileButton, accountSummaryContainer, nearRestSummaryContainer].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
        [nearRestTitleLabel, nearRestMoreButon, nearRestSubTitleLabel, nearRestCollectionView].forEach {
            nearRestSummaryContainer.addSubview($0)
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
            
            nearRestSubTitleLabel.topAnchor.constraint(equalTo: nearRestTitleLabel.bottomAnchor,constant: 15),
            nearRestSubTitleLabel.leadingAnchor.constraint(equalTo: nearRestTitleLabel.leadingAnchor),
            
            nearRestCollectionView.topAnchor.constraint(equalTo: nearRestSubTitleLabel.bottomAnchor, constant: 15),
            nearRestCollectionView.leadingAnchor.constraint(equalTo: nearRestSummaryContainer.leadingAnchor),
            nearRestCollectionView.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor),
            nearRestCollectionView.bottomAnchor.constraint(equalTo: nearRestSummaryContainer.bottomAnchor, constant: -10)
            
        ].forEach { $0.isActive = true}
    }
    
}
