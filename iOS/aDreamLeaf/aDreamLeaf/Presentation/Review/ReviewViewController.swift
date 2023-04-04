//
//  ReviewViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ReviewViewModel
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let starStackView = UIStackView()
    private let starButton1 = UIButton()
    private let starButton2 = UIButton()
    private let starButton3 = UIButton()
    private let starButton4 = UIButton()
    private let starButton5 = UIButton()
    
    private let textView = UITextView()
    private let photoButton = UIButton()
    private let saveButton = UIButton()
    
    init() {
        viewModel = ReviewViewModel()
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
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = "리뷰 작성"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "맛은 어떠셨나요?"
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        
        starStackView.spacing = 10
        
        [starButton1, starButton2, starButton3, starButton4, starButton5].forEach {
            $0.setImage(UIImage(systemName: "star.fill"), for: .normal)
            $0.tintColor = UIColor(red: 1, green: 0.8, blue: 0.1, alpha: 1)
        }
        starButton5.tintColor = .gray
        
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.text = "최소 10자 이상 입력해주세요."
        textView.textColor = .black
        textView.layer.cornerRadius = 10
        textView.contentInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        
        photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        photoButton.setTitle("사진 추가", for: .normal)
        photoButton.tintColor = .black
        photoButton.setTitleColor(.black, for: .normal)
        photoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        photoButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        
        saveButton.backgroundColor = UIColor(named: "mainColor")
        saveButton.setTitle("리뷰 작성 완료", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        [titleLabel, subtitleLabel, starStackView, textView, photoButton, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [starButton1, starButton2, starButton3, starButton4, starButton5].forEach {
            starStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            starStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            starStackView.centerXAnchor.constraint(equalTo: subtitleLabel.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 200),
            
            photoButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            photoButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            photoButton.heightAnchor.constraint(equalToConstant: 50),
            photoButton.widthAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
        ].forEach { $0.isActive = true}
    }
}
