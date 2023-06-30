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
    private let nicknameLabel = UILabel()
    private let contentTextView = UITextView()
    private let ratingLabel = UILabel()
    private let reviewImageView = UIImageView()
    
    private let menuButton = UIButton()
    private let menu = DropDown()
    
    func setUp(_ parent: ReviewListViewController, with reviewData: Review) {
        self.parent = parent
        viewModel = ReviewCellVIewModel(reviewData)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        UserManager.getInstance()
            .map { $0 == nil ? true : $0!.userId != self.viewModel.reviewerId }
            .bind(to: menuButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        menuButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.menu.show()
            })
            .disposed(by: disposeBag)
        
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index {
                case 0:
                    parent.navigationController?.pushViewController(ReviewViewController(storeId: viewModel.storeId, editData: viewModel.reviewData), animated: true)
                case 1:
                    let alert = UIAlertController(title: "확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                        // parent ViewController인 ReviewListViewController의 ViewModel에 리뷰 삭제 요청
                        self.parent.viewModel.reviewDeleteRequest.onNext(self.viewModel.reviewId)
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
        
        nicknameLabel.text = viewModel.nickname
        nicknameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        nicknameLabel.textColor = .black
        nicknameLabel.textAlignment = .left
        
        contentTextView.backgroundColor = .white
        contentTextView.text = viewModel.content
        contentTextView.font = .systemFont(ofSize: 11, weight: .regular)
        contentTextView.textColor = .gray
        contentTextView.textAlignment = .left
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        ratingLabel.font = .systemFont(ofSize: 11, weight: .light)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .left
        
        reviewImageView.isHidden = viewModel.image == nil ? true : false
        reviewImageView.image = viewModel.image
        reviewImageView.contentMode = .scaleAspectFit
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .black
        
        menu.dataSource = ["리뷰 수정", "리뷰 삭제"]
        menu.anchorView = menuButton
        menu.bottomOffset = CGPoint(x: -60, y:(menu.anchorView?.plainView.bounds.height)!)
        
    }
    
    private func layout() {
        
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        [nicknameLabel, contentTextView, ratingLabel, reviewImageView, menuButton].forEach {
            mainView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            ratingLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            
            contentTextView.topAnchor.constraint(equalTo: nicknameLabel.topAnchor, constant: -7),
            contentTextView.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor),
            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            menuButton.topAnchor.constraint(equalTo: nicknameLabel.topAnchor, constant: -7),
            menuButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 30),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            
            reviewImageView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10),
            reviewImageView.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor),
            reviewImageView.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor),
            reviewImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            
            
        ].forEach { $0.isActive = true}
        
        if viewModel.image != nil {
            reviewImageView.heightAnchor.constraint(equalTo: contentTextView.widthAnchor, constant: -50).isActive = true
        }
        
        contentView.sizeToFit()
    }
    
}
