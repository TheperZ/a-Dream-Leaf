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
    
    let nameLabel = UILabel()
    let distanceLabel = UILabel()
    let ratingLabel = UILabel()
    let stackView = UIStackView()
    let cardAvail = UILabel()
    let goodness = UILabel()
    
    
    func setUp(with: SimpleStore) {
        viewModel = SearchCellViewModel(name: with.storeName, distance: with.curDist, rating: with.totalRating, type: with.storeType)
        
        attribute()
        layout()
    }
    
    private func attribute() {
        backgroundColor = .white
        
        nameLabel.text = viewModel.name
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        
        distanceLabel.text = " \(viewModel.distance)km "
        distanceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        distanceLabel.textColor = .gray
        distanceLabel.textAlignment = .left
        
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        ratingLabel.font = .systemFont(ofSize: 13, weight: .medium)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .left
        
        stackView.spacing = 15
        
        cardAvail.text = "아동급식카드 가맹점"
        cardAvail.font = .systemFont(ofSize: 13, weight: .heavy)
        cardAvail.textColor = .white
        cardAvail.backgroundColor = UIColor(named: "subColor")
        cardAvail.textAlignment = .center
        cardAvail.layer.cornerRadius = 10
        cardAvail.isHidden = viewModel.card ? false : true
        
        goodness.text = "선한영향력"
        goodness.font = .systemFont(ofSize: 13, weight: .heavy)
        goodness.textColor = .white
        goodness.backgroundColor = UIColor(named: "subColor")
        goodness.textAlignment = .center
        goodness.isHidden = viewModel.good ? false : true
        
    }
    
    private func layout() {
        [nameLabel, distanceLabel, ratingLabel, stackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [cardAvail, goodness].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 23),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            cardAvail.widthAnchor.constraint(equalToConstant: 120),
            goodness.widthAnchor.constraint(equalToConstant: 120),
        ].forEach { $0.isActive = true }
    }
    
}
