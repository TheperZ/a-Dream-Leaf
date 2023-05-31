//
//  StoreNetwork.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/05/21.
//

import Foundation
import RxSwift
import Alamofire

struct StoreNetwork {
    func searchStore(with keyword: String) -> Observable<RequestResult<[SimpleStore]>> {
        return Observable.create { observer in
            
            let url = K.serverURL + "/restaurant/findByKeyword?keyword=\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
                
            // POST 로 보낼 정보
            let params = LocationManager.permitionCheck() ? ["curLat": LocationManager.getLatitude() ?? 0.0, "curLogt": LocationManager.getLongitude() ?? 0.0] : [:]
             
             // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
                observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
            }
            
            AF.request(request).responseJSON{ (response) in
                 switch response.result {
                     case .success:
                         do {
                             guard let result = response.data else {return}
                             
                             let decoder = JSONDecoder()
                             let data = try decoder.decode([SimpleStore].self, from: result)
                             
                             print(data)
                             
                             observer.onNext(RequestResult<[SimpleStore]>(success: true, msg: nil, data: data))
                         } catch(let error) {
                             print(error)
                             observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                         }
                             
                     case .failure(let error):
                             print("error : \(error.errorDescription!)")
                             observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                 }
             }
                
            
            
            return Disposables.create()
        }
    }
    
    func searchWithLocation(lat: Double, long: Double) -> Observable<RequestResult<[SimpleStore]>> {
        return Observable.create { observer in
            
            let url = K.serverURL + "/restaurant/findByCur".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
                
            // POST 로 보낼 정보
            let params = ["curLat": lat, "curLogt": long]
             
             // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
                observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
            }
            
            AF.request(request).responseJSON{ (response) in
                 switch response.result {
                     case .success:
                         do {
                             guard let result = response.data else {return}
                             
                             let decoder = JSONDecoder()
                             let data = try decoder.decode([SimpleStore].self, from: result)
                             
                             print(data)
                             
                             observer.onNext(RequestResult<[SimpleStore]>(success: true, msg: nil, data: data))
                         } catch(let error) {
                             print(error)
                             observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                         }
                             
                     case .failure(let error):
                             print("error : \(error.errorDescription!)")
                             observer.onNext(RequestResult<[SimpleStore]>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                 }
             }
                
            
            
            return Disposables.create()
        }
    }
    
    func fetchStoreDetail(storeId: Int) -> Observable<RequestResult<Store>> {
        return Observable.create { observer in
            
            let url = K.serverURL + "/restaurant/\(storeId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            
            AF.request(request).responseJSON{ (response) in
                 switch response.result {
                     case .success:
                         do {
                             guard let result = response.data else {return}
                             
                             let decoder = JSONDecoder()
                             let data = try decoder.decode(Store.self, from: result)
                             
                             print(data)
                             
                             observer.onNext(RequestResult<Store>(success: true, msg: nil, data: data))
                         } catch {
                             observer.onNext(RequestResult<Store>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                         }
                             
                     case .failure(let error):
                             print("error : \(error.errorDescription!)")
                             observer.onNext(RequestResult<Store>(success: false, msg: "오류가 발생했습니다! \n 잠시 후에 다시 시도해주세요!", data: nil))
                 }
             }
                
            
            
            return Disposables.create()
        }
    }
}
