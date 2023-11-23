//
//  MyPageViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MyPageViewController: UIViewController, LoadingViewController {
    var disposeBag = DisposeBag()
    var loadingView = UIActivityIndicatorView(style: .medium)
    private let viewModel: MyPageViewModel
    
    private let backButton: UIButton = {
        let button = UIButton()
        let backButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let backButtonImg = UIImage(systemName: "chevron.left", withConfiguration: backButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setImage(backButtonImg, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let nicknameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        return label
    }()
    
    private let nicknameContentLabel = UILabel()
    private let nicknameUnderLine = UIView()
    
    private let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    
    private let emailContentLabel = UILabel()
    private let emailUnderLine = UIView()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainColor")
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("계정 탈퇴", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    init() {
        viewModel = MyPageViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        
        let delete = PublishSubject<Void>()
        
        let input = MyPageViewModel.Input(logoutTrigger: logoutButton.rx.tap.asDriver(),
                                          deleteTrigger: delete.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.tranform(input: input)
        
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
        
        output.nickname
            .drive(nicknameContentLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.email
            .drive(emailContentLabel.rx.text)
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "경고", message: "한번 삭제한 계정은 복구할 수 없습니다.\n삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    delete.onNext(())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)

                alert.addAction(confirm)
                alert.addAction(cancel)

                self.present(alert, animated: true)

            })
            .disposed(by: disposeBag)
        
        output.logoutResult
            .drive(onNext: {[weak self] result in
                if result.success {
                    self?.dismiss(animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg , preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.deleteResult
            .drive(onNext: { [weak self] result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: "그 동안 이용해주셔서 감사합니다.", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self?.dismiss(animated: true)
                    }
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg , preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func uiEvent() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        [nicknameLabel, emailLabel].forEach {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        [nicknameContentLabel, emailContentLabel].forEach {
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.textAlignment = .right
        }
        
        [nicknameUnderLine, emailUnderLine].forEach {
            $0.backgroundColor = .lightGray
        }
    }
    
    private func layout() {
        
        [nicknameLabel, nicknameContentLabel].forEach { nicknameStackView.addArrangedSubview($0) }
        [emailLabel, emailContentLabel].forEach { emailStackView.addArrangedSubview($0) }
        
        [loadingView, backButton,titleLabel, nicknameStackView, nicknameUnderLine, emailStackView, emailUnderLine, logoutButton, exitButton].forEach {
            view.addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view).offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(40)
            $0.width.equalTo(300)
            $0.centerX.equalTo(view)
        }
        
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        nicknameUnderLine.snp.makeConstraints {
            $0.top.equalTo(nicknameContentLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(0.5)
        }
        
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameUnderLine.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailUnderLine.snp.makeConstraints {
            $0.top.equalTo(emailContentLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(0.5)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(emailUnderLine.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }

    }
    
}
