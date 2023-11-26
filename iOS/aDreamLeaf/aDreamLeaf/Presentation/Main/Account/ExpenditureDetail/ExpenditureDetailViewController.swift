//
//  ExpenditureDetailViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class ExpenditureDetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    var loadingView = UIActivityIndicatorView(style: .medium)
    private let viewModel: ExpenditureDetailViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    
    private let accountIdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let accountIdTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지출번호"
        return label
    }()
    
    private let accountIdLabel =  UILabel()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let priceTitleLabel:  UILabel = {
        let label = UILabel()
        label.text = "지출액"
        return label
    }()
    
    private let priceLabel =  UILabel()
    
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let dateTitleLabel:  UILabel = {
        let label = UILabel()
        label.text = "날짜"
        return label
    }()
    
    private let dateLabel =  UILabel()
    
    private let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let bodyTitleLabel:  UILabel = {
        let label = UILabel()
        label.text = "항목"
        return label
    }()
    
    private let bodyLabel =  UILabel()
    
    private let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    init(viewModel: ExpenditureDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        let delete = PublishRelay<Void>()
        
        let input = ExpenditureDetailViewModel.Input(deleteTrigger: delete.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        
        accountIdLabel.text = "\(output.expenditure.accountId)"
        titleLabel.text = output.expenditure.restaurant
        priceLabel.text = "\(output.expenditure.price)"
        dateLabel.text = output.expenditure.date
        bodyLabel.text = output.expenditure.body
        
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
        
        output.result
            .drive(onNext: { result in
                let alert = UIAlertController(title: result.success ? "성공" : "실패", message: result.success ? "정상적으로 삭제되었습니다." : "오류가 발생했습니다.", preferredStyle: .alert)
                
                let confirm = UIAlertAction(title: "삭제", style: .destructive) {[weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                
                let cancel = UIAlertAction(title: "확인", style: .cancel)
                
                if result.success {
                    alert.addAction(confirm)
                } else {
                    alert.addAction(cancel)
                }
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                let alert = UIAlertController(title: "경고", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    delete.accept(())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let vc = NewPaymentViewController(viewModel: NewPaymentViewModel(data: output.expenditure))
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func attribute() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem?.tintColor = .red
        
        [
            accountIdTitleLabel,
            priceTitleLabel,
            dateTitleLabel,
            bodyTitleLabel,
        ].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textAlignment = .left
        }
        
        [
            accountIdLabel,
            priceLabel,
            dateLabel,
            bodyLabel,
        ].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.textAlignment = .right
            $0.textColor = .gray
        }
        

        
    }
    
    private func layout() {
        [
            loadingView,
            titleLabel,
            accountIdStackView,
            priceStackView,
            dateStackView,
            bodyStackView,
            editButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [accountIdTitleLabel, accountIdLabel].forEach { accountIdStackView.addArrangedSubview($0) }
        [priceTitleLabel, priceLabel].forEach { priceStackView.addArrangedSubview($0) }
        [dateTitleLabel, dateLabel].forEach { dateStackView.addArrangedSubview($0) }
        [bodyTitleLabel, bodyLabel].forEach { bodyStackView.addArrangedSubview($0) }
        
        loadingView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalTo(view).offset(30)
            $0.trailing.equalTo(view).offset(-30)
        }
        
        accountIdStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
    
        priceStackView.snp.makeConstraints {
            $0.top.equalTo(accountIdStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(priceStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        bodyStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(bodyStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
    
    }
}
