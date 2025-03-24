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
    
    func testCallRequestToAPIServer<T: Decodable>(_ api: NetworkRequest,
                                                  _ type: T.Type,
                                                  completionHandler: @escaping (Result<T, CustomError>) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parameters, headers: api.headers)
            .validate(statusCode: 200...500)
            .responseString { response in
                dump(response)
            }
    }
    
    func callRequestToAPIServer<T: Decodable>(_ api: NetworkRequest,
                                              _ type: T.Type,
                                              completionHandler: @escaping (Result<T, CustomError>) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parameters, headers: api.headers)
            .validate(statusCode: 200...500)
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
    
    private func handleError<T>(response: DataResponse<T, AFError>, error: Error) -> CustomError {
        if let afError = error as? AFError,
           let urlError = afError.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternet
            default:
                break
            }
        }
        
        switch response.response?.statusCode {
        case 500:
            return .serverIssue
        default:
            return .askAdmin
        }
    }
}
