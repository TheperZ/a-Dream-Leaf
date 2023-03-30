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

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    let titleLabel = UILabel()
    let profileButton = UIButton()
    
    private let accountSummaryContainer = UIView()
    private let accountTitleLabel = UILabel()
    private let accountMoreButon = UIButton()
    
    private let pieChart = PieChartView()
    private let dataValues = [50000, 12000]
    
    private let usedAmountColorView = UIView()
    private let usedAmountLabel = UILabel()
    
    private let balanceColorView = UIView()
    private let balanceLabel = UILabel()
    
    private let nearRestSummaryContainer = UIView()
    private let nearRestTitleLabel = UILabel()
    private let nearRestMoreButon = UIButton()
    private let nearRestSubTitleLabel = UILabel()
    
    private let nearRestCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 120)
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
    
    init() {
        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
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
            .asDriver()
            .drive(onNext: {
//                let vc = UINavigationController(rootViewController: LoginViewController())
                let vc = MyPageViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
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
        
        accountSummaryContainer.backgroundColor = UIColor(white: 0.95, alpha: 1)
        accountSummaryContainer.layer.cornerRadius = 10
        
        accountTitleLabel.text = "가계부 요약"
        accountTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        accountTitleLabel.textColor = .black
        
        accountMoreButon.setTitle("더보기", for: .normal)
        accountMoreButon.setTitleColor(.gray, for: .normal)
        accountMoreButon.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        
        pieChart.drawEntryLabelsEnabled = false
        pieChart.legend.enabled = false
        self.setPieChartData(pieChart: self.pieChart, with: self.entryData(values: dataValues))
        
        usedAmountColorView.backgroundColor = UIColor.link
        usedAmountLabel.text = "사용액: \(dataValues[0])원"
        usedAmountLabel.textColor = .black
        usedAmountLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        balanceColorView.backgroundColor = UIColor.systemMint
        balanceLabel.text = "잔액: \(dataValues[1])원"
        balanceLabel.textColor = .black
        balanceLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        
        nearRestSummaryContainer.backgroundColor = UIColor(white: 0.95, alpha: 1)
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

        
    }
    
    private func layout() {
        [titleLabel, profileButton, accountSummaryContainer, nearRestSummaryContainer].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [accountTitleLabel, accountMoreButon, pieChart, usedAmountColorView, usedAmountLabel, balanceColorView, balanceLabel].forEach {
            accountSummaryContainer.addSubview($0)
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
            
            accountSummaryContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            accountSummaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountSummaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accountSummaryContainer.heightAnchor.constraint(equalToConstant: 200),
            
            accountTitleLabel.topAnchor.constraint(equalTo: accountSummaryContainer.topAnchor, constant: 10),
            accountTitleLabel.leadingAnchor.constraint(equalTo: accountSummaryContainer.leadingAnchor, constant: 15),
            
            accountMoreButon.trailingAnchor.constraint(equalTo: accountSummaryContainer.trailingAnchor, constant: -10),
            accountMoreButon.centerYAnchor.constraint(equalTo: accountTitleLabel.centerYAnchor),
            accountMoreButon.widthAnchor.constraint(equalToConstant: 60),
            
            pieChart.topAnchor.constraint(equalTo: accountTitleLabel.bottomAnchor, constant: 10),
            pieChart.leadingAnchor.constraint(equalTo: accountTitleLabel.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: accountSummaryContainer.centerXAnchor, constant: -10),
            pieChart.bottomAnchor.constraint(equalTo: accountSummaryContainer.bottomAnchor, constant: -10),
            
            usedAmountColorView.heightAnchor.constraint(equalToConstant: 15),
            usedAmountColorView.widthAnchor.constraint(equalToConstant: 15),
            usedAmountColorView.leadingAnchor.constraint(equalTo: accountSummaryContainer.centerXAnchor, constant: 10),
            usedAmountColorView.bottomAnchor.constraint(equalTo: pieChart.centerYAnchor, constant: -10),
            
            usedAmountLabel.leadingAnchor.constraint(equalTo: usedAmountColorView.trailingAnchor, constant: 10),
            usedAmountLabel.centerYAnchor.constraint(equalTo: usedAmountColorView.centerYAnchor),
            
            balanceColorView.heightAnchor.constraint(equalToConstant: 15),
            balanceColorView.widthAnchor.constraint(equalToConstant: 15),
            balanceColorView.leadingAnchor.constraint(equalTo: accountSummaryContainer.centerXAnchor, constant: 10),
            balanceColorView.bottomAnchor.constraint(equalTo: pieChart.centerYAnchor, constant: 10),
            
            balanceLabel.leadingAnchor.constraint(equalTo: balanceColorView.trailingAnchor, constant: 10),
            balanceLabel.centerYAnchor.constraint(equalTo: balanceColorView.centerYAnchor),
            
            nearRestSummaryContainer.topAnchor.constraint(equalTo: accountSummaryContainer.bottomAnchor, constant: 40),
            nearRestSummaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nearRestSummaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nearRestSummaryContainer.heightAnchor.constraint(equalToConstant: 200),
            
            nearRestTitleLabel.topAnchor.constraint(equalTo: nearRestSummaryContainer.topAnchor, constant: 10),
            nearRestTitleLabel.leadingAnchor.constraint(equalTo: nearRestSummaryContainer.leadingAnchor, constant: 15),
            
            nearRestMoreButon.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor, constant: -10),
            nearRestMoreButon.centerYAnchor.constraint(equalTo: nearRestTitleLabel.centerYAnchor),
            nearRestMoreButon.widthAnchor.constraint(equalToConstant: 60),
            
            nearRestSubTitleLabel.topAnchor.constraint(equalTo: nearRestTitleLabel.bottomAnchor,constant: 15),
            nearRestSubTitleLabel.leadingAnchor.constraint(equalTo: nearRestTitleLabel.leadingAnchor),
            
            nearRestCollectionView.topAnchor.constraint(equalTo: nearRestSubTitleLabel.bottomAnchor, constant: 10),
            nearRestCollectionView.leadingAnchor.constraint(equalTo: nearRestTitleLabel.leadingAnchor),
            nearRestCollectionView.trailingAnchor.constraint(equalTo: nearRestSummaryContainer.trailingAnchor),
            nearRestCollectionView.bottomAnchor.constraint(equalTo: nearRestSummaryContainer.bottomAnchor, constant: -10)
            
        ].forEach { $0.isActive = true}
    }
    
}


//MARK: - PieChart

extension HomeViewController {
    private func setPieChartData(pieChart: PieChartView, with: [ChartDataEntry]) {
        
        let dataSet = PieChartDataSet(entries: with, label: "가계부 요약")
        dataSet.colors = colorsOfCharts()
        dataSet.drawValuesEnabled = false
        dataSet.label = ""
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
        
    }
    
    private func entryData(values: [Int]) -> [PieChartDataEntry] {
        var dataEntries = [PieChartDataEntry]()
        
        for i in 0..<values.count {
            let dataEntry = PieChartDataEntry(value: Double(dataValues[i]))
            dataEntries.append(dataEntry)
        }
        
        return dataEntries
    }
    
    private func colorsOfCharts() -> [UIColor] {
        return [UIColor.link, UIColor.systemMint]
    }
}
