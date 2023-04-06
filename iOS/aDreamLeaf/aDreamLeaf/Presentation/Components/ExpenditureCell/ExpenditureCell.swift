//
//  ExpenditureCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/05.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenditureCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: ExpenditureCellViewModel!
    
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let costLabel = UILabel()
    private let balanceLabel = UILabel()
    
    func setUp(with: (date: Date, title: String, cost: Int)) {
        viewModel = ExpenditureCellViewModel(date: with.date, title: with.title, cost: with.cost)
        
        attribute()
        layout()
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd."
        dateLabel.text = dateFormatter.string(from: viewModel.date)
        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        
        titleLabel.text = viewModel.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        costLabel.text = "\(NumberUtil.commaString(viewModel.cost)!)원"
        costLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        costLabel.textColor = UIColor(named: "subColor")
        costLabel.textAlignment = .right
        
        balanceLabel.text = "12,000원"
        balanceLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        balanceLabel.textColor = .lightGray
        balanceLabel.textAlignment = .right
    }
    
    private func layout() {
        [dateLabel, titleLabel, costLabel, balanceLabel].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: costLabel.leadingAnchor),
            
            costLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            costLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            costLabel.widthAnchor.constraint(equalToConstant: 70),
            
            balanceLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 10),
            balanceLabel.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor),
            balanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ].forEach { $0.isActive = true }
    }
    
}
