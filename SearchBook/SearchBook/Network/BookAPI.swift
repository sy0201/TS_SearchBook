//
//  BookAPI.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/27/24.
//

import Foundation
import Moya

enum BookAPI {
    case getBookInfo(searchText: String)
}

extension BookAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        switch self {
        case .getBookInfo(_):
            return "/v3/search/book"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBookInfo(searchText: _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBookInfo(let searchText):
            let params: [String: Any] = [
                "query": searchText
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let apiKey = Bundle.main.apiKey
        return ["Authorization": apiKey ?? ""]
    }
    
    var sampleData: Data {
        let sampleJSON = """
        {
            "documents": [
                {
                    "authors": ["Author Name"],
                    "contents": "Book summary...",
                    "datetime": "2022-01-01T00:00:00.000+09:00",
                    "isbn": "1234567890",
                    "price": 10000,
                    "publisher": "Publisher Name",
                    "sale_price": 9000,
                    "status": "정상판매",
                    "thumbnail": "http://image.url",
                    "title": "Book Title",
                    "translators": [],
                    "url": "http://book.url"
                }
            ],
            "meta": {
                "is_end": true,
                "pageable_count": 1,
                "total_count": 100
            }
        }
        """
        return Data(sampleJSON.utf8)
    }
}
