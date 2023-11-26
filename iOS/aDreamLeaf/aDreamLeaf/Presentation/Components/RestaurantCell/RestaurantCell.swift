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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let goodImageView: UIImageView = {
        let imageView = UIImageView()
        let goodConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .default)
        let goodImg = UIImage(systemName: "leaf", withConfiguration: goodConfig)?.withRenderingMode(.alwaysTemplate)
        imageView.image = goodImg
        imageView.tintColor = UIColor(named: "subColor")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        let cardConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .default)
        let cardImg = UIImage(systemName: "creditcard", withConfiguration: cardConfig)?.withRenderingMode(.alwaysTemplate)
        imageView.image = cardImg
        imageView.tintColor = UIColor(named: "subColor")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    func setUp(viewModel: RestaurantCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        nameLabel.text = viewModel.name
        
        ratingLabel.text = "⭐️ \(String(format: "%.1f", viewModel.rating))"
        
        distanceLabel.text = "\(String(format: "%.2f", viewModel.distance))m"
        
        goodImageView.isHidden = viewModel.type == 0 || viewModel.type == 2 ? false : true
        
        cardImageView.isHidden = viewModel.type == 1 || viewModel.type == 2 ? false : true
        
    }
    
    private func attribute() {
        contentView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        contentView.layer.cornerRadius = 10
    }
    
    private func layout() {
        [nameLabel, ratingLabel, distanceLabel, stackView].forEach {
            self.contentView.addSubview($0)
        }
        
        [goodImageView, cardImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).offset(-15)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(distanceLabel.snp.bottom).offset(4)
            $0.leading.equalTo(contentView).offset(15)
            $0.height.equalTo(25)
        }
        
        goodImageView.snp.makeConstraints {
            $0.width.equalTo(25)
        }
        
        cardImageView.snp.makeConstraints {
            $0.width.equalTo(25)
        }
        
    }
}
