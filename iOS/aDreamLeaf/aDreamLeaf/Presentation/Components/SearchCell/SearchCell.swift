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
    let disposeBag = DisposeBag()
    var viewModel: SearchCellViewModel!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        if LocationManager.permitionCheck() == false { // 위치 정보 비동의시 거리 표기 X
            label.isHidden = true
        }
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    

    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        return stackView
    }()
    
    let cardAvail: UILabel = {
        let label = UILabel()
        label.text = "아동급식카드 가맹점"
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "subColor")
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        return label
    }()
    
    let goodness: UILabel = {
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
        [nameLabel, distanceLabel, ratingLabel, stackView].forEach {
            contentView.addSubview($0)
        }
        
        [cardAvail, goodness].forEach {
            stackView.addArrangedSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView)
        }
        
        ratingLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel)
        }
        
        distanceLabel.snp.makeConstraints{
            $0.top.equalTo(ratingLabel)
            $0.leading.equalTo(ratingLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(contentView).offset(-10)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(23)
            $0.bottom.equalTo(contentView).offset(-15)
        }
        
        cardAvail.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
        goodness.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
    }
    
}
