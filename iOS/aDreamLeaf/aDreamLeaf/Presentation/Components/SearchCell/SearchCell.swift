//
//  SearchCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/31.
//

import UIKit
import RxSwift
import RxCocoa

class SearchCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: SearchCellViewModel!
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private let rateDistStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let goodCardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        if LocationManager.permitionCheck() == false { // 위치 정보 비동의시 거리 표기 X
            label.isHidden = true
        }
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private let cardAvail: UILabel = {
        let label = UILabel()
        label.text = "아동급식카드 가맹점"
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "subColor")
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        return label
    }()
    
    private let goodness: UILabel = {
        let label = UILabel()
        label.text = "선한영향력"
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "subColor")
        label.textAlignment = .center
        return label
    }()
    
    
    
    func setUp(viewModel: SearchCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        nameLabel.text = viewModel.name
        distanceLabel.text = " \(String(format: "%.1f", viewModel.distance))km "
        ratingLabel.text = "⭐️ \(String(format: "%.1f", viewModel.rating))"
        cardAvail.isHidden = viewModel.card ? false : true
        goodness.isHidden = viewModel.good ? false : true
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        
        [nameLabel, rateDistStackView, goodCardStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [distanceLabel, ratingLabel].forEach {
            rateDistStackView.addArrangedSubview($0)
        }
        
        [goodness, cardAvail].forEach {
            goodCardStackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        cardAvail.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.width.equalTo(120)
        }
        
        goodness.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.width.equalTo(120)
        }
        
    }
    
}
