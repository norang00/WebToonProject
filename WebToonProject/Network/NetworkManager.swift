//
//  NetworkManager.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation
import Alamofire
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequestToAPIServer<T: Decodable>(_ api: NetworkRequest,
                                              _ type: T.Type,
                                completionHandler: @escaping (Result<T, CustomError>) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parameters)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { [weak self] response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    guard let customError = self?.handleError(response: response, error: error) else { return }
                    completionHandler(.failure(customError))
                }
            }
    }
    
    private func handleError<T>(response: DataResponse<T, AFError>,
                                error: Error) -> CustomError {
        switch response.response?.statusCode {
        case 400: return .statusCode_400
        case 401: return .statusCode_401
        case 429: return .statusCode_429
        case 500: return .statusCode_500
        default: return .defaultCase
        }
    }
}

enum CustomError: String, Error {
    case statusCode_400 = "잘못된 요청입니다. 요청 내용을 확인해보세요."
    case statusCode_401 = "권한이 없습니다. 관리자에게 문의하세요."
    case statusCode_429 = "호출 한도를 초과했습니다. 잠시 후 다시 시도해주세요."
    case statusCode_500 = "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
    case defaultCase = "관리자에게 문의하세요."
}
