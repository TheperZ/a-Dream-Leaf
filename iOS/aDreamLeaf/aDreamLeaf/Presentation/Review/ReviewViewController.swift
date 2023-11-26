//
//  ReviewViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ReviewViewController: UIViewController {
    var disposeBag = DisposeBag()
    var loadingView = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: ReviewViewModel
    private let selectedImage = BehaviorSubject<UIImage?>(value: nil)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰 작성"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "맛은 어떠셨나요?"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let starButton1 = UIButton()
    private let starButton2 = UIButton()
    private let starButton3 = UIButton()
    private let starButton4 = UIButton()
    private let starButton5 = UIButton()
    private let starButtonList: [UIButton]
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.textColor = .black
        textView.layer.cornerRadius = 10
        textView.contentInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        return textView
    }()
    
    private let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.setTitle("사진 추가", for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "subColor")
        button.setTitle("리뷰 작성 완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    private let textViewWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "최소 10글자 이상 입력해주세요."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    
    private let imagePicker = UIImagePickerController()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    init(storeId: Int, editData: Review? = nil) {
        viewModel = ReviewViewModel(storeId: storeId, editData: editData)
        starButtonList = [starButton1, starButton2, starButton3, starButton4, starButton5]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let selectedRatingBtnIdx = BehaviorSubject(value: 5)
        
        starButtonList.enumerated().forEach { idx, btn in
            btn.rx.tap
                .asDriver()
                .drive(onNext: {
                    var p = false
                    for b in self.starButtonList {
                        if p == false {
                            b.tintColor = UIColor(red: 1, green: 0.8, blue: 0.1, alpha: 1)
                            if b == btn {
                                p = true
                            }
                        } else {
                            b.tintColor = .gray
                        }

                    }
                })
                .disposed(by: disposeBag)
                
            btn.rx.tap
                .map { idx + 1 }
                .bind(to: selectedRatingBtnIdx)
                .disposed(by: disposeBag)
        }
        
        let input = ReviewViewModel.Input(trigger: saveButton.rx.tap.asDriver(),
                                          rating: selectedRatingBtnIdx.asDriver(onErrorJustReturn: 5),
                                          body: textView.rx.text.orEmpty.asDriver(),
                                          image: selectedImage.asDriver(onErrorJustReturn: nil))
        
        let output = viewModel.transform(input: input)
        
        if output.isEdit {
            guard let data = output.editData else { return }
            starButtonList[data.rating-1].sendActions(for: .touchUpInside)
            textView.rx.text.onNext(data.body)
            if let reviewImage = data.reviewImage { // 리뷰에 사진이 포함된 경우
                selectedImage.onNext(Image.base64ToImg(with: reviewImage))
            }
        }
    
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
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                if result.success {
                    let alert = UIAlertController(title: "성공", message: output.isEdit ? "리뷰가 정상적으로 수정 되었습니다!" : "리뷰가 정상적으로 작성 되었습니다!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func uiEvent() {
        selectedImage
            .map { img in
                if img == nil { // 리뷰에 포함된 이미지가 없을 때 기본 이미지 ( 사진 모양 ) 표시
                    let photoImgConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light, scale: .default)
                    let photoImg = UIImage(systemName: "photo", withConfiguration: photoImgConfig)?.withRenderingMode(.alwaysTemplate)
                    self.imageView.contentMode = .center
                    return photoImg!
                } else {
                    self.imageView.contentMode = .scaleAspectFit
                    return img!
                }
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        photoButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    return
                }
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true // 사진 편집 유무
                self.present(self.imagePicker, animated: true)
            })
            .disposed(by: disposeBag)

        textView.rx.text
            .orEmpty
            .map { $0.count != 0 ? true : false}
            .bind(to: textViewWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
        [starButton1, starButton2, starButton3, starButton4, starButton5].forEach {
            $0.setImage(UIImage(systemName: "star.fill"), for: .normal)
            $0.tintColor = UIColor(red: 1, green: 0.8, blue: 0.1, alpha: 1)
            $0.adjustsImageWhenHighlighted = false
        }
        
        imagePicker.delegate = self
    
    }
    
    private func layout() {
        [ titleLabel, subtitleLabel, starStackView, textView, textViewWarningLabel, photoButton, saveButton, imageView, loadingView].forEach {
            view.addSubview($0)
        }
        
        [starButton1, starButton2, starButton3, starButton4, starButton5].forEach {
            starStackView.addArrangedSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view).offset(30)
            $0.trailing.equalTo(view).offset(-30)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        starStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(subtitleLabel)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(starStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(200)
        }
        
        textViewWarningLabel.snp.makeConstraints {
            $0.top.equalTo(textView).offset(23)
            $0.leading.equalTo(titleLabel).offset(20)
            $0.trailing.equalTo(titleLabel)
        }
        
        photoButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.trailing.equalTo(titleLabel)
            $0.height.width.equalTo(50)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(photoButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }
    }
}


extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController4. - 사진을 선택하거나, 카메라 촬영하고 나면 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage.onNext(image)
            dismiss(animated: true)
        }
    }

}
