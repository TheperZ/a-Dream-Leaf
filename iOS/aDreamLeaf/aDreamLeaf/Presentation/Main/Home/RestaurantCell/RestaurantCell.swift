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
    let disposeBag = DisposeBag()
    var viewModel: RestaurantCellViewModel!
    
    let nameLabel = UILabel()
    let ratingLabel = UILabel()
    let distanceLabel = UILabel()
    
    func setUp(with: (name: String, rating: Double, distance: Double)) {
        viewModel = RestaurantCellViewModel(name: with.name, rating: with.rating, distance: with.distance)
        
        attribute()
        layout()
    }
    
    func attribute() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        nameLabel.text = viewModel.name
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .black
        
        ratingLabel.text = "★ \(viewModel.rating)"
        ratingLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        ratingLabel.textColor = .black
        
        distanceLabel.text = "\(Int(viewModel.distance))m"
        distanceLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        distanceLabel.textColor = .gray
    }
    
    func layout() {
        [nameLabel, ratingLabel, distanceLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5),
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
        
        ].forEach { $0.isActive = true }
    }
}
