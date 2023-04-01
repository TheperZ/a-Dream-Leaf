//
//  SimpleReviewCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleReviewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: SimpleReviewCellViewModel!
    
    private let nicknameLabel = UILabel()
    private let contentLabel = UILabel()
    
    func setUp(with: (nickname: String, content: String)) {
        viewModel = SimpleReviewCellViewModel(nickname: with.nickname, content: with.content)
        
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
        
        contentLabel.text = viewModel.content
        contentLabel.font = .systemFont(ofSize: 15, weight: .light)
        contentLabel.textColor = .gray
        contentLabel.textAlignment = .left
    }
    
    private func layout() {
        [nicknameLabel, contentLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nicknameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 85),
            
            contentLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ].forEach { $0.isActive = true }
    }
}
