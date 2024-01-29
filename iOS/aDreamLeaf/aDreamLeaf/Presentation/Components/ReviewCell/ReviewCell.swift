//
//  ReviewCell.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class ReviewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var viewModel: ReviewCellVIewModel!
    private var parent: ReviewListViewController!
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .top
        return stackView
    }()
    
    private let nickRateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let bodyImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = .systemFont(ofSize: 11, weight: .regular)
        textView.textColor = .gray
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["리뷰 수정", "리뷰 삭제"]
        return menu
    }()
    
    func setUp(_ parent: ReviewListViewController, viewModel: ReviewCellVIewModel) {
        self.parent = parent
        self.viewModel = viewModel
        
        bind()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bind() {
        menuButton.isHidden = !viewModel.isMine
        nicknameLabel.text = viewModel.nickname
        contentTextView.text = viewModel.content
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        reviewImageView.isHidden = viewModel.image == nil ? true : false
        
        if let image = viewModel.image {
            reviewImageView.image = image
        } else {
            reviewImageView.isHidden = true
        }
        
    }
    
    private func uiEvent() {
        menuButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.menu.show()
            })
            .disposed(by: disposeBag)
        
        menu.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            switch index {
                case 0:
                    parent.navigationController?.pushViewController(ReviewViewController(storeId: viewModel.storeId, editData: viewModel.reviewData), animated: true)
                case 1:
                    let alert = UIAlertController(title: "확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                        self.parent.deleteRequest.onNext(self.viewModel.reviewId)
                    }
                    let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                    alert.addAction(confirm)
                    alert.addAction(cancel)
                    
                    self.parent.present(alert, animated: true)
                default:
                    break
            }
        }
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        
        [nickRateStackView, bodyImageStackView, menuButton].forEach{
            stackView.addArrangedSubview($0)
        }
        
        [nicknameLabel, ratingLabel].forEach{
            nickRateStackView.addArrangedSubview($0)
        }
        
        [contentTextView, reviewImageView].forEach {
            bodyImageStackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(10)
            $0.trailing.bottom.equalTo(contentView).offset(-10)
        }
        
        nickRateStackView.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        reviewImageView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(bodyImageStackView.snp.width)
        }
        
        
    }
    
}
