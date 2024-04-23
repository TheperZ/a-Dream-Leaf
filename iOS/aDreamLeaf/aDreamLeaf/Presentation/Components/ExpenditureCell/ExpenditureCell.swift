//
//  ExpenditureCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ExpenditureCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: ExpenditureCellViewModel!
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.alignment = .top
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "subColor")
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    
    func setUp(viewModel: ExpenditureCellViewModel) {
        self.viewModel = viewModel
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        costLabel.text = "\(NumberUtil.commaString(viewModel.cost)!)원"
        bodyLabel.text = viewModel.body
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        
        [dateLabel, contentStackView, costLabel].forEach{
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel, bodyLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}
