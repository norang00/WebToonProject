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

enum Day: String {
    case mon = "MON"
    case tue = "TUE"
    case wed = "WED"
    case thu = "THU"
    case fri = "FRI"
    case sat = "SAT"
    case sun = "SUN"
}

enum NetworkRequest {
    case webtoon(keyword: String?, page: Int?, sort: Sort?, isUpdated: Bool?, isFree: Bool?, day: Day?)
    
    var webtoonURL: String {
        return API.URL.webtoon.rawValue
    }
        
    var endpoint: URL {
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
        case .webtoon(let keyword, let page, let sort, let isUpdated, let isFree, let day):
            let params: [String: Any?] = [
                "provider": "NAVER",
                "keyword": keyword,
                "page": page,
                "perPage": 30,
                "sort": sort,
                "isUpdated": isUpdated,
                "isFree": isFree,
                "day": day
            ]
            return params.compactMapValues { $0 }
        }
    }
}
