//
//  AccountSettingViewModel.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/04/06.
//

import Foundation
import RxSwift
import RxRelay

class AccountSettingViewModel: LoadingViewModel {
    private let disposeBag = DisposeBag()
    var loading: PublishSubject<Bool>
    
    let amount = PublishSubject<Int>()
    
    let alarmState = PublishSubject<Bool>()
    
    let saveBtnTap = PublishRelay<Void>()
    let alarmSwitchChanged = PublishSubject<Bool>()
    
    let budgetSettingResult = PublishSubject<RequestResult<Void>>()
    let alarmStateResult = PublishSubject<RequestResult<AlarmState>>()
    let alarmRequestResult = PublishSubject<RequestResult<Void>>()
    
    init(_ accountRepo: AccountRepository = AccountRepository(), _ alarmRepo: AlarmRepository = AlarmRepository()) {
        
        loading = PublishSubject<Bool>()
        
        // 예산 저장 버튼 클릭 혹은 알림 설정 스위치 변경 시 로딩 시작
        saveBtnTap
            .map { _ in return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        alarmSwitchChanged
            .map { _ in return true }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        // 예산 저장 결과 혹은 알림 설정 변경 결과 응답 시 로딩 종료
        budgetSettingResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        alarmRequestResult
            .map { _ in return false }
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        // 예산 저장 버튼 클릭 시 서버에 예산 비용 저장 요청
        saveBtnTap
            .withLatestFrom(amount)
            .flatMap(accountRepo.setBudget)
            .bind(to: budgetSettingResult)
            .disposed(by: disposeBag)
        
        //최초 알림 설정 값 가져오기
        alarmRepo.getState()
            .bind(to: alarmStateResult)
            .disposed(by: disposeBag)
        
        alarmSwitchChanged
            .flatMap { isOn in
                if isOn {
                    return alarmRepo.register()
                } else {
                    return alarmRepo.deregister()
                }
            }
            .bind(to: alarmRequestResult)
            .disposed(by: disposeBag)
        
        alarmStateResult
            .filter { $0.data != nil }
            .map { $0.data!.exist }
            .bind(to: alarmState)
            .disposed(by: disposeBag)
    }
}
