//
//  StoreMapViewController.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/31.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap

class StoreMapViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: StoreMapViewModel
    private let tapGesture = UITapGestureRecognizer()
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.backgroundColor = .white
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "음식점 위치"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let topView = UIView()
    private let mapView = NMFMapView()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    
    init(viewModel: StoreMapViewModel) {
        self.viewModel = viewModel
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
    
    private func bind(){
        
        let input = StoreMapViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        storeNameLabel.text = output.storeName
        addressLabel.text = output.address
        
        output.markers.forEach {
            $0.mapView = mapView
        }
        
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 모든 마커를 포함하는 경계 계산
                let bounds = NMGLatLngBounds(latLngs: output.markers.map { $0.position })
                // 지도의 화면을 계산된 경계로 이동
                self.mapView.moveCamera(NMFCameraUpdate(fit: bounds, padding: 40)) { _ in
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        tapGesture.addTarget(self, action: #selector(didTapView))
        topView.addGestureRecognizer(tapGesture)
    }
    
    private func layout() {
        [topView, contentView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, closeButton, mapView, storeNameLabel, addressLabel, loadingView].forEach {
            contentView.addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(mapView)
        }
        
        topView.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(contentView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(450)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(contentView).offset(-10)
            $0.height.width.equalTo(30)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView).offset(-150)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(mapView)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(storeNameLabel)
        }
    
    }
    
    @objc
    private func didTapView() {
        self.dismiss(animated: true)
    }
}
