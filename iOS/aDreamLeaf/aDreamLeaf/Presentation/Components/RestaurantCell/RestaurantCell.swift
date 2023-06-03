//
//  RestaurantCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: RestaurantCellViewModel!
    
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let distanceLabel = UILabel()
    
    private let stackView = UIStackView()
    private let goodImageView = UIImageView()
    private let cardImageView = UIImageView()
    
    func setUp(with: SimpleStore) {
        viewModel = RestaurantCellViewModel(name: with.storeName, rating: with.totalRating, distance: with.curDist, type: with.storeType)
        
        attribute()
        layout()
    }
    
    func attribute() {
        
        contentView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        contentView.layer.cornerRadius = 10
        
        nameLabel.text = viewModel.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .black
        
        ratingLabel.text = "⭐️ \(String(format: "%.1f", viewModel.rating))"
        ratingLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        ratingLabel.textColor = .black
        
        distanceLabel.text = "\(String(format: "%.2f", viewModel.distance))m"
        distanceLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        distanceLabel.textColor = .gray
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let goodConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .default)
        let goodImg = UIImage(systemName: "leaf", withConfiguration: goodConfig)?.withRenderingMode(.alwaysTemplate)
        goodImageView.image = goodImg
        goodImageView.tintColor = UIColor(named: "subColor")
        goodImageView.contentMode = .scaleAspectFit
        goodImageView.isHidden = viewModel.type == 0 || viewModel.type == 2 ? false : true
        
        let cardConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .default)
        let cardImg = UIImage(systemName: "creditcard", withConfiguration: cardConfig)?.withRenderingMode(.alwaysTemplate)
        cardImageView.image = cardImg
        cardImageView.tintColor = UIColor(named: "subColor")
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.isHidden = viewModel.type == 1 || viewModel.type == 2 ? false : true
    }
    
    func layout() {
        [nameLabel, ratingLabel, distanceLabel, stackView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [goodImageView, cardImageView].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.heightAnchor.constraint(equalToConstant: 25),
            
            goodImageView.widthAnchor.constraint(equalToConstant: 25),
            cardImageView.widthAnchor.constraint(equalToConstant: 25),
        
        ].forEach { $0.isActive = true }
    }
}
