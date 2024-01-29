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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        return stackView
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        contentView.addSubview(stackView)
        
        [nicknameLabel, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
