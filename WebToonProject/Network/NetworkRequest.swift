//
//  NetworkRequest.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation
import Alamofire

enum Sort: String {
    case asc = "ASC"
    case desc = "DESC"
}

// Parameter pack for Webtoon Request
struct WebtoonRequestOption {
    var keyword: String? = nil
    var page: Int? = 1
    var sort: Sort? = nil
    var isUpdated: Bool? = nil
    var isFree: Bool? = nil
    var updateDay: String? = nil
}

// Parameter pack for Naver Image Request
struct ImageRequestOption {
    var keyword: String? = nil
    var display: Int? = 10
}

enum NetworkRequest {
    case webtoon(option: WebtoonRequestOption)
    case image(option: ImageRequestOption)
    
    var webtoonURL: String {
        return API.URL.webtoon.rawValue
    }
    
    var imageURL: String {
        return API.URL.image.rawValue
    }
        
    var endpoint: URL {
        switch self {
        case .webtoon:
            return URL(string: webtoonURL)!
        case .image(option: let option):
            return URL(string: imageURL)!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders {
        switch self {
        case .webtoon:
            return []
        case .image:
            return [
                "X-Naver-Client-Id" : API.Key.naverClient,
                "X-Naver-Client-Secret" : API.Key.naverSecret
            ]
        }
    }

    var parameters: Parameters {
        switch self {
        case .webtoon(let option):
            let params: [String: Any?] = [
                "provider": "NAVER",
                "keyword": option.keyword,
                "page": option.page,
                "perPage": 30,
                "sort": option.sort?.rawValue,
                "isUpdated": option.isUpdated,
                "isFree": option.isFree,
                "updateDay": option.updateDay
            ]
            return params.compactMapValues { $0 }
        case .image(option: let option):
            let params: [String: Any?] = [
                "query": option.keyword,
                "display": option.display
            ]
            return params.compactMapValues { $0 }
        }
    }
}
