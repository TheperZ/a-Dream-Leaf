//
//  ReviewListViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewListViewController : UIViewController {
    private let disposeBag = DisposeBag()
    let viewModel: ReviewListViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tableView = UITableView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let reviewListEmptyWarnLabel = UILabel()
    
    
    init(storeData: Store) {
        viewModel = ReviewListViewModel(storeData: storeData)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reviewListUpdateRequest.onNext(Void())
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
                
                cell.setUp(self, with: review)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.reviews
            .map { "리뷰 (\($0.count))" }
            .bind(to: subtitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.reviewDeleteResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                let alert = UIAlertController(title: result.success ? "성공" : "실패", message: result.msg, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .default)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reviews
            .map { $0.count != 0 }
            .observe(on: MainScheduler.instance)
            .bind(to: reviewListEmptyWarnLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = viewModel.storeData.storeName
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "리뷰"
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        
        tableView.backgroundColor = .white
        
        reviewListEmptyWarnLabel.text = "작성된 리뷰가 없습니다 🥲"
        reviewListEmptyWarnLabel.textColor = .black
        reviewListEmptyWarnLabel.font = .systemFont(ofSize: 15, weight: .bold)
        reviewListEmptyWarnLabel.textAlignment = .center

    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, subtitleLabel, tableView, reviewListEmptyWarnLabel].forEach {
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
            contentView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            
            reviewListEmptyWarnLabel.topAnchor.constraint(equalTo: tableView.topAnchor),
            reviewListEmptyWarnLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            reviewListEmptyWarnLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            reviewListEmptyWarnLabel.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
            
        ].forEach { $0.isActive = true }
        
    }
    
}
