//
//  ReviewListViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ReviewListViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ReviewListViewModel
    
    let deleteRequest = PublishSubject<Int>()

    private let loadingView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.backgroundColor = .white
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: ContentWrappingTableView = {
        let tableView = ContentWrappingTableView()
        tableView.backgroundColor = .white
        tableView.register(ReviewCell.self, forCellReuseIdentifier: K.TableViewCellID.ReviewCell)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let reviewListEmptyWarnLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 리뷰가 없습니다 🥲"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    
    
    init(viewModel: ReviewListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in ()}.asDriver(onErrorJustReturn: ())
        
        let input = ReviewListViewModel.Input(viewWillAppear: viewWillAppear,
                                              deleteTrigger: deleteRequest.asDriver(onErrorJustReturn: -1))
        
        let output = viewModel.transfrom(input: input)
        
        output.loading
            .drive(onNext: { [weak self] loading in
                if loading {
                    self?.loadingView.startAnimating()
                    self?.loadingView.isHidden = false
                } else {
                    self?.loadingView.stopAnimating()
                    self?.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.reviews
            .drive(tableView.rx.items) { tv, row, review in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ReviewCell, for: indexPath) as! ReviewCell

                cell.setUp(self, viewModel: ReviewCellVIewModel(review))

                return cell
            }
            .disposed(by: disposeBag)
        
        output.reviews
            .map { "리뷰 (\($0.count))" }
            .drive(subtitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.reviews
            .map { $0.count != 0 }
            .drive(reviewListEmptyWarnLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.storeName
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        
        [scrollView, loadingView, reviewListEmptyWarnLabel].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(topStackView)
        
        [titleLabel, subtitleLabel, tableView].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.width.equalTo(scrollView).offset(-20)
            $0.leading.equalTo(scrollView).offset(10)
            $0.trailing.equalTo(scrollView).offset(-10)
            $0.bottom.equalTo(scrollView).offset(-20)
        }
        
        reviewListEmptyWarnLabel.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
        
    }
    
}


class ContentWrappingTableView: UITableView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}
