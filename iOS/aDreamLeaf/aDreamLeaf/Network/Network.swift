//
//  Network.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/08/18.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkMethod: String {
    case POST
    case GET
}

enum NetworkType {
    case SignUp
    case Login
    case Profile
    case Account
    case Kakao
    case Store
    case Review
    case Alarm
}

enum NetworkError: String, Error {
    case invalidURL = "잘못된 URL 입니다."
    case invalidJSON = "잘못된 JSON 형식입니다."
    case networkError = "네트워크 에러입니다."
    case invalidQuery = "잘못된 Parameter 입니다."
    case invalidRequest = "잘못된 요청입니다."
    case serverError = "서버에서 오류가 발생했습니다."
    case decodingError = "디코딩 과정에서 에러가 발생했습니다."
}

class Network {
    
    let type: NetworkType
    
    init(type: NetworkType) {
        self.type = type
    }
    
    func makeRequest(url: String, method: NetworkMethod, params:[String: Any]? = nil, header: [String: String]? = nil) -> URLRequest {
        let url = K.serverURL + url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let header = header {
            header.keys.forEach { key in
                request.setValue(header[key], forHTTPHeaderField: key)
            }
        }
        request.timeoutInterval = 10
         
        // httpBody 에 parameters 추가
        do {
            if let params = params {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch {
            print("HTTP Request Body Error")
        }
        
        return request
    }
    
    
    
    // Decoding할 데이터가 포함된 응답 처리
    func handleResponse<T: Decodable>(response: AFDataResponse<Data>, observer: AnyObserver<Result<T, Error>>) {
        switch response.result {
            case .success:
                do {
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                            case 200..<300:
                                guard let result = response.data else {return}
                                
                                let decoder = JSONDecoder()
                                let data = try decoder.decode(T.self, from: result)
                                
                                observer.onNext(.success(data))
                            case 404, 400:
                                guard let result = response.data else { return }
                                let decoder = JSONDecoder()
                                let data = try decoder.decode(ErrorResponse.self, from: result)
                                print("\(self.type) Error - ",data.ErrorMessage)
                                observer.onNext(.failure(NetworkError.invalidRequest))
                                
                            default:
                                print("\(self.type) Error - Unknown status code: \(statusCode)")
                                observer.onNext(.failure(NetworkError.serverError))
                        }
                    }
                } catch(let error) {
                    print(error)
                    observer.onNext(.failure(NetworkError.decodingError))
                }
                    
            case .failure(let error):
                print("error : \(error.errorDescription!)")
                observer.onNext(.failure(NetworkError.networkError))
        }
    }
    
    // Decoding할 데이터가 포함되지 않은 응답 처리
    func handleResponse(response: AFDataResponse<Data>, observer: AnyObserver<Result<Void, Error>>) {
        switch response.result {
            case .success:
                do {
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                            case 200..<300:
                                observer.onNext(.success(()))
                                
                            case 400..<500:
                                guard let result = response.data else { return }
                                let decoder = JSONDecoder()
                                let data = try decoder.decode(ErrorResponse.self, from: result)
                                print("\(self.type) Error - ",data.ErrorMessage)
                                observer.onNext(.failure(NetworkError.invalidRequest))
                                
                            default:
                                print("\(self.type) Error - Unknown status code: \(statusCode)")
                                observer.onNext(.failure(NetworkError.serverError))
                        }
                    }
                } catch(let error) {
                    print(error)
                    observer.onNext(.failure(NetworkError.decodingError))
                }
                    
            case .failure(let error):
                print("error : \(error.errorDescription!)")
                observer.onNext(.failure(NetworkError.networkError))
        }
    }
}
