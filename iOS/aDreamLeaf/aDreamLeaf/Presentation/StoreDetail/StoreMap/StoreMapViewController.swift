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

    private let contentView = UIView()
    private let topView = UIView()
    private let mapView = NMFMapView()
    private let marker = NMFMarker()
    private let closeButton = UIButton()
    
    init(data: Store) {
        self.viewModel = StoreMapViewModel(data)
        
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
        mapView.latitude = viewModel.latitude
        mapView.longitude = viewModel.longitude
        marker.captionText = viewModel.storeName
        
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
        
        topView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapView))
        
        contentView.backgroundColor = UIColor.white
        
        mapView.zoomLevel = 15
        
        marker.position = NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude)
        marker.mapView = mapView
        
        marker.captionTextSize = 12
        marker.captionRequestedWidth = 100

        marker.width = 30
        marker.height = 40
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    private func layout() {
        [topView, contentView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [closeButton, mapView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2 + 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            mapView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ].forEach { $0.isActive = true }
    }
    
    @objc
    private func didTapView() {
        self.dismiss(animated: true)
    }
}
