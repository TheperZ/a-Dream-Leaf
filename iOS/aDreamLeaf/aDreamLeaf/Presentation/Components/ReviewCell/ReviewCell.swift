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
    
    private let mainView = UIView()
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
        
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        [nicknameLabel, contentTextView, ratingLabel, reviewImageView, menuButton].forEach {
            mainView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        menu.anchorView = menuButton
        menu.bottomOffset = CGPoint(x: -60, y:(menu.anchorView?.plainView.bounds.height)!)
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(mainView)
            $0.leading.equalTo(mainView).offset(10)
            $0.width.equalTo(100)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameLabel).offset(5)
            $0.trailing.equalTo(nicknameLabel)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel).offset(-7)
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalTo(menuButton.snp.leading)
            $0.height.greaterThanOrEqualTo(30)
        }
        
        menuButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel).offset(-7)
            $0.trailing.equalTo(mainView)
            $0.height.width.equalTo(30)
        }
        
        reviewImageView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentTextView)
            $0.bottom.equalTo(mainView)
            $0.height.equalTo(viewModel.image != nil ? reviewImageView.snp.width : 0)
        }

    }
    
}
