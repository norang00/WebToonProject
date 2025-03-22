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

// Parameter packs for Webtoon Request
struct WebtoonRequestOption {
    var keyword: String? = nil
    var page: Int? = 1
    var sort: Sort? = nil
    var isUpdated: Bool? = nil
    var isFree: Bool? = nil
    var updateDay: String? = nil
}

enum NetworkRequest {
    case webtoon(option: WebtoonRequestOption)
    
    var webtoonURL: String {
        return API.URL.webtoon.rawValue
    }
        
    var endpoint: URL { // 필요없을지도?
        switch self {
        case .webtoon:
            return URL(string: webtoonURL)!
        }
    }
    
    var method: HTTPMethod {
        return .get
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
        }
    }
}
