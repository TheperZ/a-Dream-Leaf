//
//  ReviewViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/03.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

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
    private let starButtonList: [UIButton]
    private let textView = UITextView()
    private let photoButton = UIButton()
    private let saveButton = UIButton()
    
    private let textViewWarningLabel = UILabel()
    
    private let imagePicker = UIImagePickerController()
    private let imageView = UIImageView()
    
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
        attribute()
        layout()
    }
    
    private func bind() {
        
        
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
                .map { return idx+1 }
                .bind(to: viewModel.rating)
                .disposed(by: disposeBag)
        }
        
        photoButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    print("사용불가 + 사용자에게 토스트/얼럿")
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
        
        textView.rx.text
            .orEmpty
            .bind(to: viewModel.body)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.saveBtnTap)
            .disposed(by: disposeBag)
        
        viewModel.createRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.success {
                    let alert = UIAlertController(title: "성공", message: "리뷰가 정상적으로 작성 되었습니다!", preferredStyle: .alert)
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
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
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
            $0.adjustsImageWhenHighlighted = false
        }
        
        // 수정인 경우 초기값 설정
        if viewModel.editData != nil {
            textView.text = viewModel.editData!.body
            starButtonList[viewModel.editData!.rating-1].sendActions(for: .touchUpInside)
        }
        
        textViewWarningLabel.text = "최소 10글자 이상 입력해주세요."
        textViewWarningLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textViewWarningLabel.textColor = .gray
        textViewWarningLabel.textAlignment = .left
        
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.textColor = .black
        textView.layer.cornerRadius = 10    
        textView.contentInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        
        photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        photoButton.setTitle("사진 추가", for: .normal)
        photoButton.tintColor = .black
        photoButton.setTitleColor(.black, for: .normal)
        photoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        photoButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        
        saveButton.backgroundColor = UIColor(named: "subColor")
        saveButton.setTitle("리뷰 작성 완료", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        
        imagePicker.delegate = self
        
        let photoImgConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light, scale: .default)
        let photoImg = UIImage(systemName: "photo", withConfiguration: photoImgConfig)?.withRenderingMode(.alwaysTemplate)
        imageView.image = photoImg
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.5
    }
    
    private func layout() {
        [titleLabel, subtitleLabel, starStackView, textView, textViewWarningLabel, photoButton, saveButton, imageView].forEach {
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
            
            textViewWarningLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 23),
            textViewWarningLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 20),
            
            photoButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            photoButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            photoButton.heightAnchor.constraint(equalToConstant: 50),
            photoButton.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
        ].forEach { $0.isActive = true}
    }
}


extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController4. - 사진을 선택하거나, 카메라 촬영하고 나면 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = image
            viewModel.image.onNext(image)
            dismiss(animated: true)
        }
    }
    
    // UIImagePickerController5. - 취소 버튼을 누르면 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function, "🦋 취소버튼 클릭 시")
    }
}
