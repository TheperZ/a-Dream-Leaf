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
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let chartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let chartInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let chartInfoSubStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        return stackView
    }()
    
    private let chartInfoSubStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
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
        view.addSubview(accountSummaryContainer)
        
        [topStackView, cover].forEach {
            accountSummaryContainer.addSubview($0)
        }
        
        [titleStackView, chartStackView].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [accountTitleLabel, accountMoreButton].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [pieChart, chartInfoStackView].forEach {
            chartStackView.addArrangedSubview($0)
        }
        
        [chartInfoSubStackView1, chartInfoSubStackView2].forEach {
            chartInfoStackView.addArrangedSubview($0)
        }
        
        [usedAmountColorView, usedAmountLabel].forEach {
            chartInfoSubStackView1.addArrangedSubview($0)
        }
        
        [balanceColorView, balanceLabel].forEach {
            chartInfoSubStackView2.addArrangedSubview($0)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        pieChart.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
        usedAmountColorView.snp.makeConstraints{
            $0.width.height.equalTo(15)
        }
        
        balanceColorView.snp.makeConstraints {
            $0.width.height.equalTo(15)
        }
        
        
        cover.contentView.addSubview(coverStackView)
        
        [coverMessageTextView, gotoLoginButton].forEach {
            coverStackView.addArrangedSubview($0)
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
