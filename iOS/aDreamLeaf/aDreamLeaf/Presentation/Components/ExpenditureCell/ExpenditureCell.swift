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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
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
        [dateLabel, titleLabel, costLabel, bodyLabel].forEach{
            contentView.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.equalTo(contentView)
            $0.width.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing)
            $0.trailing.equalTo(costLabel.snp.leading)
        }
        
        costLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel)
            $0.trailing.equalTo(contentView)
            $0.width.equalTo(120)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(costLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(contentView).offset(-15)
        }

    }
    
}
