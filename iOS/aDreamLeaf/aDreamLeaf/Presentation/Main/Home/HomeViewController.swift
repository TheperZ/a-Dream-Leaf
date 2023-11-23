//
//  HomeViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

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
        
        bindViewModel()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        selectStore: nearRestCollectionView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.nearStores
            .drive(nearRestCollectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCellID.RestaurantCell, for: indexPath) as! RestaurantCell
                cell.setUp(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .asDriver()
            .withLatestFrom(output.login)
            .drive(onNext: { login in
                if login {
                    let vc = MyPageViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    let vc = UINavigationController(rootViewController: LoginViewController(viewModel: LoginViewModel()))
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        
        
        nearRestMoreButon.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(LocalRestaurantViewController(viewModel: LocalRestaurantViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedStore
            .drive(onNext: { store in
                self.navigationController?.pushViewController(StoreDetailViewController(storeId: store.storeId), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.nearStores
            .map { $0.count != 0 }
            .drive(nearRestEmptyAlertLabel.rx.isHidden)
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
        }
    
        [nearRestTitleLabel, nearRestMoreButon, nearRestSubTitleLabel, nearRestCollectionView, nearRestEmptyAlertLabel].forEach {
            nearRestSummaryContainer.addSubview($0)
        }
        
        [goodInfoImageView, goodInfoTextLabel, cardInfoImageView, cardInfoTextLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view).offset(20)
        }
        
        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(view).offset(-20)
        }
        
        accountSummaryContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalTo(view).offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }
        
        nearRestSummaryContainer.snp.makeConstraints {
            $0.top.equalTo(accountSummaryContainer.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(200)
        }
        
        nearRestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nearRestSummaryContainer).offset(20)
            $0.leading.equalTo(nearRestSummaryContainer).offset(30)
        }
        
        nearRestMoreButon.snp.makeConstraints {
            $0.trailing.equalTo(nearRestSummaryContainer).offset(-15)
            $0.centerY.equalTo(nearRestTitleLabel)
            $0.width.equalTo(60)
        }
        
        nearRestSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nearRestTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nearRestTitleLabel)
        }
        
        nearRestCollectionView.snp.makeConstraints {
            $0.top.equalTo(nearRestSubTitleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nearRestSummaryContainer)
            $0.bottom.equalTo(nearRestSummaryContainer).offset(-10)
        }
        
        nearRestEmptyAlertLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(nearRestCollectionView)
            $0.leading.equalTo(nearRestCollectionView).offset(20)
            $0.trailing.equalTo(nearRestCollectionView).offset(-20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(nearRestSummaryContainer.snp.bottom).offset(5)
            $0.trailing.equalTo(nearRestSummaryContainer).offset(-15)
        }
        
    }
    
}
