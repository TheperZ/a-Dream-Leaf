//
//  SimpleReviewCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimpleReviewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: SimpleReviewCellViewModel!
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    
    func setUp(viewModel: SimpleReviewCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        nicknameLabel.text = viewModel.nickname
        contentLabel.text = viewModel.content
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        [nicknameLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.leading.equalTo(contentView)
            $0.width.equalTo(85)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-10)
        }
        
    }
}
