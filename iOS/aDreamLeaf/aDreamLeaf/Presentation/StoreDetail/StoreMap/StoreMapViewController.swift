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
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let topView = UIView()
    private let mapView = NMFMapView()
    private let myPos = NMFMarker()
    private let marker = NMFMarker()
    private var markers = [NMFMarker]()
    private let storeNameLabel = UILabel()
    private let addressLabel = UILabel()
    
    init(data: Store) {
        self.viewModel = StoreMapViewModel(data)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if markers.count > 1 { // 현재 위치를 표시하는 마커가 생성된 경우
            // 모든 마커를 포함하는 경계 계산
            let bounds = NMGLatLngBounds(latLngs: markers.map { $0.position })
            // 지도의 화면을 계산된 경계로 이동
            mapView.moveCamera(NMFCameraUpdate(fit: bounds, padding: 40)) // padding 값은 경계 주위에 여백을 설정합니다.
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
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
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "음식점 위치"
        titleLabel.textColor = .black
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        configMap()
        
        storeNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        storeNameLabel.text = viewModel.storeName
        storeNameLabel.textColor = .black
        
        addressLabel.font = .systemFont(ofSize: 13)
        addressLabel.text = viewModel.address
        addressLabel.textColor = .darkGray
        addressLabel.numberOfLines = 2
    }
    
    private func layout() {
        [topView, contentView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel, closeButton, mapView, storeNameLabel, addressLabel].forEach {
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
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            
            storeNameLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            storeNameLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            storeNameLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: storeNameLabel.trailingAnchor),
            
        ].forEach { $0.isActive = true }
    }
    
    
    private func configMap() {
        if LocationManager.permitionCheck() {
            myPos.position = NMGLatLng(lat: LocationManager.getLatitude(), lng: LocationManager.getLongitude())
            myPos.mapView = mapView
            myPos.width = 40
            myPos.height = 40
            myPos.iconImage = .init(image: UIImage(named: "myPosMarker")!)
            markers.append(myPos)
            
            
        }
        
        mapView.zoomLevel = 15
        mapView.latitude = viewModel.latitude
        mapView.longitude = viewModel.longitude
        
        markers.append(marker)
    
        marker.position = NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude)
        marker.mapView = mapView

        marker.width = 40
        marker.height = 40
        marker.iconImage = .init(image: UIImage(named: "storeMarker")!)
    }
    
    @objc
    private func didTapView() {
        self.dismiss(animated: true)
    }
}
