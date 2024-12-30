//
//  BookModel.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/27/24.
//

import Foundation

struct BookResult: Decodable {
    let bookModels: [BookModel]
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case bookModels = "documents" // "documents" 키를 "bookModels"에 매핑
        case meta
    }
}

struct BookModel: Decodable, Hashable {
    let authors: [String]?
    let contents: String?
    let datetime: String?
    let isbn: String?
    let price: Int?
    let publisher: String?
    let salePrice: Int?  // 확인: API가 null 또는 문자열로 반환할 경우 optional로 선언
    let status: String?  // 확인: Status 열거형 대신 문자열로 선언
    let thumbnail: String?
    let title: String?
    let translators: [String]?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher, status, thumbnail, title, translators, url
        case salePrice = "sale_price"
    }
}

enum Status: String, Codable {
    case 정상판매 = "정상판매"
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
