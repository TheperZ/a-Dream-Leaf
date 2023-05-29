//
//  ReviewCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: ReviewCellVIewModel!
    
    private let mainView = UIView()
    private let nicknameLabel = UILabel()
    private let contentTextView = UITextView()
    private let ratingLabel = UILabel()
    private let reviewImageView = UIImageView()
    
    func setUp(with reviewData: Review) {
        viewModel = ReviewCellVIewModel(reviewData)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
        
        nicknameLabel.text = viewModel.nickname
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .light)
        nicknameLabel.textColor = .black
        nicknameLabel.textAlignment = .left
        
        contentTextView.backgroundColor = .white
        contentTextView.text = viewModel.content
        contentTextView.font = .systemFont(ofSize: 15, weight: .light)
        contentTextView.textColor = .gray
        contentTextView.textAlignment = .left
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        ratingLabel.font = .systemFont(ofSize: 14, weight: .light)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .left
        
        reviewImageView.isHidden = viewModel.image == nil ? true : false
        reviewImageView.image = viewModel.image
        reviewImageView.contentMode = .scaleAspectFit
        
    }
    
    private func layout() {
        
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        [nicknameLabel, contentTextView, ratingLabel, reviewImageView].forEach {
            mainView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            ratingLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            
            contentTextView.topAnchor.constraint(equalTo: nicknameLabel.topAnchor, constant: -5),
            contentTextView.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            reviewImageView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10),
            reviewImageView.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor),
            reviewImageView.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor),
            reviewImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            
            
        ].forEach { $0.isActive = true}
        
        if viewModel.image != nil {
            reviewImageView.heightAnchor.constraint(equalTo: contentTextView.widthAnchor, constant: -50).isActive = true
        }
        
        contentView.sizeToFit()
    }
    
}
