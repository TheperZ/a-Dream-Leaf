//
//  ReviewViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ReviewViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tableView = UITableView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    init() {
        viewModel = ReviewViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: K.TableViewCellID.ReviewCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        
        viewModel.reviews
            .bind(to: tableView.rx.items) { tv, row, review in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ReviewCell, for: indexPath) as! ReviewCell
                
                cell.setUp(with: review)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = "피자스쿨 목2동점"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "리뷰 (5)"
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .black
        
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.tintColor = .black
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, subtitleLabel, tableView, leftButton, rightButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 780),
            
            leftButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            leftButton.widthAnchor.constraint(equalToConstant: 30),
            leftButton.heightAnchor.constraint(equalToConstant: 30),
            leftButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -30),
            
            rightButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            rightButton.widthAnchor.constraint(equalToConstant: 30),
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            rightButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 30),
            rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ].forEach { $0.isActive = true }
        
        
    }
}
