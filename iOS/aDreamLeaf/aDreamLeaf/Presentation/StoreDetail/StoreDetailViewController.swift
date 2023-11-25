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
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let mapButton: UIButton = {
        let button = UIButton()
        button.setTitle("지도 보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor(white: 0.90, alpha: 1).cgColor
        return button
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let cardAvail: UILabel = {
        let label = UILabel()
        label.text = "아동급식카드 가맹점"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "subColor2")
        label.layer.borderColor = UIColor(named: "subColor2")?.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    private let goodness: UILabel = {
        let label = UILabel()
        label.text = "선한 영향력 가게"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "subColor2")
        label.layer.borderColor = UIColor(named: "subColor2")?.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let hygieneGradeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    
    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let serviceConditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let reviewTitle: UIButton = {
        let button = UIButton()
        button.setTitle("리뷰", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let reviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("리뷰 작성", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    private let reviewWarningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "작성된 리뷰가 없습니다"
        label.textColor = .gray
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0.97, alpha: 1)
        return label
    }()
    
    
    init(viewModel: StoreDetailViewModel) {
        self.viewModel = viewModel
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
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = StoreDetailViewModel.Input(trigger: viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
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
        
        output.store
            .drive(onNext: {[weak self] store in
                guard let self = self, let store = store else {
                    let alert = UIAlertController(title: "실패", message: "가게를 찾을 수 없습니다.", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                    return
                }
                self.nameLabel.text = store.storeName
                self.distanceLabel.text = "[ 내 위치로 부터 \(store.curDist != 0.0 ? StringUtil.getRefinedDistance(with:store.curDist) : "-km") ]"
                self.hygieneGradeLabel.text = "식약청 위생등급 : \(store.hygieneGrade == "" ? "없음" : store.hygieneGrade)"
                self.ratingLabel.text = "⭐️ \(String(format: "%.1f", store.totalRating))"
                
                if store.storeType == 1 {
                    self.serviceLabel.isHidden = true
                    self.serviceConditionLabel.isHidden = true
                } else {
                    self.serviceLabel.text = "🌱 제공 혜택 : \(store.prodName ?? "-")"
                    self.serviceLabel.isHidden = false
                    self.serviceConditionLabel.text = "✅ 제공 조건 : \(store.prodTarget ?? "-")"
                    self.serviceConditionLabel.isHidden = false
                }
                
                switch(store.storeType) {
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
        
        output.reviews
            .map { $0.count == 0 ? false: true }
            .drive(reviewWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        reviewButton.rx.tap
            .asDriver()
            .withLatestFrom(output.store)
            .drive(onNext: { [weak self] store in
                guard let self = self, let store = store else { return }
                self.navigationController?.pushViewController(ReviewViewController(storeId: store.storeId), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.login
            .drive(onNext: { [weak self] login in
                if login {
                    self?.reviewButton.alpha = 1
                    self?.reviewButton.isEnabled = true
                } else {
                    self?.reviewButton.alpha = 0.3
                    self?.reviewButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        output.reviews
            .drive(reviewTableView.rx.items) { [weak self] tv, row, review in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self?.reviewTableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.SimpleReviewCell, for: indexPath) as! SimpleReviewCell
                cell.setUp(viewModel: SimpleReviewCellViewModel(review))
                return cell
            }
            .disposed(by: disposeBag)
        
        mapButton.rx.tap
            .asDriver()
            .withLatestFrom(output.store)
            .drive(onNext: { [weak self] store in
                guard let self = self, let store = store else { return }
                let pvc = StoreMapViewController(viewModel: StoreMapViewModel(store))
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.modalTransitionStyle = .coverVertical
                self.present(pvc, animated: true)
            })
            .disposed(by: disposeBag)
        
        reviewTitle.rx.tap
            .asDriver()
            .withLatestFrom(output.store)
            .drive(onNext: { [weak self] store in
                guard let self = self, let store = store else { return }
                self.navigationController?.pushViewController(ReviewListViewController(viewModel: ReviewListViewModel(storeData: store)), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [nameLabel, addressStackView, distanceLabel, topStackView, bottomStackView, serviceLabel, serviceConditionLabel, divider, reviewTitle, reviewTableView, reviewButton, reviewWarningLabel, loadingView].forEach {
            view.addSubview($0)
        }
        
        [distanceLabel, mapButton].forEach {
            addressStackView.addArrangedSubview($0)
        }
        
        [goodness, cardAvail].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [hygieneGradeLabel, ratingLabel].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(30)
        }
        
        addressStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
        }
        
        mapButton.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(distanceLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        cardAvail.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        goodness.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        hygieneGradeLabel.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        serviceLabel.snp.makeConstraints {
            $0.top.equalTo(bottomStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        serviceConditionLabel.snp.makeConstraints {
            $0.top.equalTo(serviceLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(serviceConditionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(serviceConditionLabel)
            $0.height.equalTo(0.2)
        }
        
        reviewTitle.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(30)
            $0.leading.equalTo(divider.snp.leading)
        }
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(reviewTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(divider)
            $0.height.equalTo(150)
        }
        
        reviewWarningLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(reviewTableView)
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(reviewTableView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(reviewTableView)
            $0.bottom.equalTo(contentView).offset(-30)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
