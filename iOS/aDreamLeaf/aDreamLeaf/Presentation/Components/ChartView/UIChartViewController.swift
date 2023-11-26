//
//  ChartView.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class UIChartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let chartViewModel: UIChartViewModel
    let selectedDate = BehaviorSubject<Date>(value:Date.now)
    
    private var cover: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let cover = UIVisualEffectView(effect: blurEffect)
        cover.clipsToBounds = true
        return cover
    }()
    
    private let coverStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let coverMessageTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.text = "로그인이 필요한 기능입니다!\n로그인을 해주세요!"
        textView.font = .systemFont(ofSize: 15, weight: .semibold)
        textView.textColor = .darkGray
        textView.textAlignment = .center
        return textView
    }()
    
    private let gotoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "subColor2")
        button.setTitle("로그인하러 가기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let accountSummaryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let accountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가계부 요약"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    
    private let pieChart: PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawEntryLabelsEnabled = false
        pieChart.legend.enabled = false
        return pieChart
    }()
    
    private let usedAmountColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)
        return view
    }()
    
    private let usedAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let accountMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        return button
    }()
    
    private let balanceColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "subColor")!
        return view
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
    init(viewModel: UIChartViewModel) {
        self.chartViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        chartLayout()
    }
    
    private func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = UIChartViewModel.Input(trigger: Driver.merge(viewWillAppear, selectedDate.map { _ in ()}.asDriver(onErrorJustReturn: ()) ),
                                           date: selectedDate.asDriver(onErrorJustReturn: .now))
        
        let output = chartViewModel.transform(input: input)
        
        output.login
            .drive(cover.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.data
            .drive(onNext: {[weak self] data in
                guard let self = self else { return }
                self.setPieChartData(pieChart: self.pieChart, with: self.entryData(values: data))
                self.usedAmountLabel.text = "사용액: \(NumberUtil.commaString(data[0])!)원"
                self.balanceLabel.text = "잔액: \(NumberUtil.commaString(data[1])!)원"
            })
            .disposed(by: disposeBag)

    }
    
    private func uiEvent() {
        gotoLoginButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                let vc = UINavigationController(rootViewController: LoginViewController(viewModel: LoginViewModel()))
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        accountMoreButton.rx.tap
            .asDriver()
            .drive(onNext:{
                self.tabBarController?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
    }
    
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
            let dataEntry = PieChartDataEntry(value: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        return dataEntries
    }
    
    private func colorsOfCharts() -> [UIColor] {
        return [UIColor(white: 0.85, alpha: 1), UIColor(named: "subColor")!]
    }
    
    private func chartLayout() {
        
        [accountTitleLabel, accountMoreButton, pieChart, usedAmountColorView, usedAmountLabel, balanceColorView, balanceLabel, cover].forEach {
            accountSummaryContainer.addSubview($0)
        }
        
        cover.contentView.addSubview(coverStackView)
        
        [coverMessageTextView, gotoLoginButton].forEach {
            coverStackView.addArrangedSubview($0)
        }
        
        accountSummaryContainer.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        accountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(accountSummaryContainer).offset(10)
            $0.leading.equalTo(accountSummaryContainer).offset(15)
        }
        
        accountMoreButton.snp.makeConstraints {
            $0.trailing.equalTo(accountSummaryContainer).offset(-10)
            $0.centerY.equalTo(accountTitleLabel)
            $0.width.equalTo(60)
        }
        
        pieChart.snp.makeConstraints {
            $0.top.equalTo(accountTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(accountTitleLabel)
            $0.trailing.equalTo(accountSummaryContainer.snp.centerX).offset(-10)
            $0.bottom.equalTo(accountSummaryContainer).offset(-10)
        }
        
        usedAmountColorView.snp.makeConstraints {
            $0.height.width.equalTo(15)
            $0.leading.equalTo(accountSummaryContainer.snp.centerX).offset(10)
            $0.bottom.equalTo(pieChart.snp.centerY).offset(-10)
        }
        
        usedAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(usedAmountColorView.snp.trailing).offset(10)
            $0.centerY.equalTo(usedAmountColorView)
        }
        
        balanceColorView.snp.makeConstraints {
            $0.height.width.equalTo(15)
            $0.leading.equalTo(accountSummaryContainer.snp.centerX).offset(10)
            $0.bottom.equalTo(pieChart.snp.centerY).offset(10)
        }
        
        balanceLabel.snp.makeConstraints {
            $0.leading.equalTo(balanceColorView.snp.trailing).offset(10)
            $0.centerY.equalTo(balanceColorView)
        }
        
        cover.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(accountSummaryContainer)
        }
        
        coverStackView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.center.equalTo(cover.contentView)
        }
        
        coverMessageTextView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        gotoLoginButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
    
    func hideMoreButton() {
        accountMoreButton.isHidden = true
    }
}
