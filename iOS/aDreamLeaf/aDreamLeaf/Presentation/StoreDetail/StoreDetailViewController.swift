//
//  StoreDetailViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class StoreDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: StoreDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let distanceLabel = UILabel()
    private let topStackView = UIStackView()
    private let cardAvail = UILabel()
    private let goodness = UILabel()
    private let bottomStackView = UIStackView()
    private let hygieneGradeLabel = UILabel()
    private let ratingLabel = UILabel()
    
    private let divider = UIView()
    
    private let reviewTitle = UIButton()
    private let reviewTableView = UITableView()
    
    init() {
        viewModel = StoreDetailViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.register(SimpleReviewCell.self, forCellReuseIdentifier: K.TableViewCellID.SimpleReviewCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        viewModel.reviews
            .take(2)
            .bind(to: reviewTableView.rx.items) { tv, row, review in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.reviewTableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.SimpleReviewCell, for: indexPath) as! SimpleReviewCell
                
                cell.setUp(with: review)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = .white
        
        nameLabel.text = "피자스쿨 목2동점"
        nameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        addressLabel.text = "서울 양천구 등촌로 172 등촌빌딩"
        addressLabel.font = .systemFont(ofSize: 15, weight: .light)
        addressLabel.textColor = .black
        addressLabel.textAlignment = .center
        
        distanceLabel.text = "[ 내 위치로 부터 0.3km ]"
        distanceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        distanceLabel.textColor = .gray
        distanceLabel.textAlignment = .center
        
        topStackView.spacing = 10
        topStackView.distribution = .fillEqually
        
        cardAvail.text = "아동급식카드 가맹점"
        cardAvail.font = .systemFont(ofSize: 16, weight: .semibold)
        cardAvail.textColor = UIColor(named: "subColor2")
        cardAvail.layer.borderColor = UIColor(named: "subColor2")?.cgColor
        cardAvail.layer.borderWidth = 1
        cardAvail.layer.cornerRadius = 10
        cardAvail.textAlignment = .center
        
        goodness.text = "선한 영향력 가게"
        goodness.font = .systemFont(ofSize: 16, weight: .semibold)
        goodness.textColor = .lightGray
        goodness.layer.borderColor = UIColor.gray.cgColor
        goodness.layer.borderWidth = 1
        goodness.layer.cornerRadius = 10
        goodness.textAlignment = .center
        
        bottomStackView.spacing = 10
        bottomStackView.distribution = .fillEqually
        
        hygieneGradeLabel.text = "식약청 위생등급 : 1등급"
        hygieneGradeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        hygieneGradeLabel.textColor = .black
        hygieneGradeLabel.layer.borderColor = UIColor.black.cgColor
        hygieneGradeLabel.layer.borderWidth = 1
        hygieneGradeLabel.layer.cornerRadius = 10
        hygieneGradeLabel.textAlignment = .center
        
        ratingLabel.text = "⭐️ 4.5"
        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.textColor = .black
        ratingLabel.layer.borderColor = UIColor.black.cgColor
        ratingLabel.layer.borderWidth = 1
        ratingLabel.layer.cornerRadius = 10
        ratingLabel.textAlignment = .center
        
        divider.backgroundColor = .black
        
        reviewTitle.setTitle("리뷰", for: .normal)
        reviewTitle.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        reviewTitle.tintColor = .black
        reviewTitle.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        reviewTitle.setTitleColor(.black, for: .normal)
        reviewTitle.semanticContentAttribute = .forceRightToLeft
        
        reviewTableView.isScrollEnabled = false
        reviewTableView.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, addressLabel, distanceLabel, topStackView, bottomStackView, divider, reviewTitle, reviewTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [cardAvail, goodness].forEach {
            topStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [hygieneGradeLabel, ratingLabel].forEach {
            bottomStackView.addArrangedSubview($0)
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
            
            nameLabel.widthAnchor.constraint(equalToConstant: 300),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            addressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            distanceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            topStackView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor,constant: 20),
            topStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            cardAvail.heightAnchor.constraint(equalToConstant: 40),
            goodness.heightAnchor.constraint(equalToConstant: 40),
            
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor,constant: 10),
            bottomStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            hygieneGradeLabel.heightAnchor.constraint(equalToConstant: 40),
            ratingLabel.heightAnchor.constraint(equalToConstant: 40),
            
            divider.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.2),
            
            reviewTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 30),
            reviewTitle.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            
            reviewTableView.topAnchor.constraint(equalTo: reviewTitle.bottomAnchor, constant: 10),
            reviewTableView.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            reviewTableView.trailingAnchor.constraint(equalTo: divider.trailingAnchor),
            reviewTableView.heightAnchor.constraint(equalToConstant: 150),
            reviewTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ].forEach { $0.isActive = true }
    }
}
