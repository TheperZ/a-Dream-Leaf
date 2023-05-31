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
    private let addressStackView = UIStackView()
    private let addressLabel = UILabel()
    private let mapButton = UIButton()
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
    private let reviewButton = UIButton()
    private let reviewWarningLabel = UILabel()
    
    init(storeId: Int) {
        viewModel = StoreDetailViewModel(storeId: storeId)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchReviewRequest.onNext(Void())
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
        
        reviewTitle.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.detail)
            .subscribe(onNext: { storeData in
                self.navigationController?.pushViewController(ReviewListViewController(storeData: storeData), animated: true)
            })
            .disposed(by: disposeBag)
        
        reviewButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(ReviewViewController(storeId: self.viewModel.storeId), animated: true)
            })
            .disposed(by: disposeBag)
        
        mapButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.detail)
            .subscribe(onNext: {
                let pvc = StoreMapViewController(data: $0)
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.modalTransitionStyle = .coverVertical
                self.present(pvc, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        UserManager.getInstance()
            .observe(on: MainScheduler.instance)
            .map { userData in
                if userData != nil {
                    self.reviewButton.alpha = 1
                    return true
                } else {
                    self.reviewButton.alpha = 0.3
                    return false
                }
            }
            .bind(to: reviewButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .map { $0.storeName}
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .map { $0.refineRoadnmAddr}
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .map { "[ 내 위치로 부터 \($0.curDist)km ]" }
            .bind(to: distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .map { "식약청 위생등급 : \($0.hygieneGrade)" }
            .observe(on: MainScheduler.instance)
            .bind(to: hygieneGradeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .map { "⭐️ \($0.totalRating)" }
            .observe(on: MainScheduler.instance)
            .bind(to: ratingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                switch($0.storeType) {
                    case 0:
                        self.cardAvail.font = .systemFont(ofSize: 16, weight: .semibold)
                        self.cardAvail.textColor = .lightGray
                        self.cardAvail.layer.borderColor = UIColor.gray.cgColor
                        self.cardAvail.layer.borderWidth = 1
                        self.cardAvail.layer.cornerRadius = 10
                        self.cardAvail.textAlignment = .center
                        
                    case 1:
                        self.goodness.font = .systemFont(ofSize: 16, weight: .semibold)
                        self.goodness.textColor = .lightGray
                        self.goodness.layer.borderColor = UIColor.gray.cgColor
                        self.goodness.layer.borderWidth = 1
                        self.goodness.layer.cornerRadius = 10
                        self.goodness.textAlignment = .center
                        
                    default:
                        return
                        
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.reviews
            .map { $0.count == 0 ? false: true}
            .bind(to: reviewWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
    }
    
    private func attribute() {
        navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = .white
        
        nameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        addressStackView.spacing = 10
        
        addressLabel.font = .systemFont(ofSize: 15, weight: .light)
        addressLabel.textColor = .black
        addressLabel.textAlignment = .center
        
        mapButton.setTitle("지도 보기", for: .normal)
        mapButton.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        mapButton.setTitleColor(.black, for: .normal)
        mapButton.layer.cornerRadius = 5
        mapButton.layer.backgroundColor = UIColor(white: 0.90, alpha: 1).cgColor
        
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
        goodness.textColor = UIColor(named: "subColor2")
        goodness.layer.borderColor = UIColor(named: "subColor2")?.cgColor
        goodness.layer.borderWidth = 1
        goodness.layer.cornerRadius = 10
        goodness.textAlignment = .center
        
        bottomStackView.spacing = 10
        bottomStackView.distribution = .fillEqually
        
        hygieneGradeLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        hygieneGradeLabel.textColor = .black
        hygieneGradeLabel.layer.borderColor = UIColor.black.cgColor
        hygieneGradeLabel.layer.borderWidth = 1
        hygieneGradeLabel.layer.cornerRadius = 10
        hygieneGradeLabel.textAlignment = .center
        
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
        
        reviewButton.setTitle("리뷰 작성", for: .normal)
        reviewButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        reviewButton.setTitleColor(.black, for: .normal)
        reviewButton.layer.cornerRadius = 10
        reviewButton.layer.borderColor = UIColor.black.cgColor
        reviewButton.layer.borderWidth = 0.5
        
        reviewWarningLabel.font = .systemFont(ofSize: 14, weight: .bold)
        reviewWarningLabel.text = "작성된 리뷰가 없습니다"
        reviewWarningLabel.textColor = .gray
        reviewWarningLabel.textAlignment = .center
        reviewWarningLabel.backgroundColor = UIColor(white: 0.97, alpha: 1)
        
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, addressStackView, distanceLabel, topStackView, bottomStackView, divider, reviewTitle, reviewTableView, reviewButton, reviewWarningLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [addressLabel, mapButton].forEach {
            addressStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [goodness, cardAvail].forEach {
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
            
            addressStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            addressStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            mapButton.widthAnchor.constraint(equalToConstant: 50),
            
            distanceLabel.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 20),
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
            
            reviewWarningLabel.topAnchor.constraint(equalTo: reviewTableView.topAnchor),
            reviewWarningLabel.leadingAnchor.constraint(equalTo: reviewTableView.leadingAnchor),
            reviewWarningLabel.trailingAnchor.constraint(equalTo: reviewTableView.trailingAnchor),
            reviewWarningLabel.bottomAnchor.constraint(equalTo: reviewTableView.bottomAnchor),
        
            reviewButton.topAnchor.constraint(equalTo: reviewTableView.bottomAnchor, constant: 10),
            reviewButton.leadingAnchor.constraint(equalTo: reviewTableView.leadingAnchor),
            reviewButton.trailingAnchor.constraint(equalTo: reviewTableView.trailingAnchor),
            reviewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
        ].forEach { $0.isActive = true }
    }
}
