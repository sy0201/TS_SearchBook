//
//  BookRepository.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/30/24.
//

import Foundation
import Moya
import RxSwift
import RxMoya

protocol BookRepositoryProtocol {
    func fetchBooks(searchText: String) -> Observable<BookResult>
}

final class BookRepository: BookRepositoryProtocol {
    private let provider = MoyaProvider<BookAPI>()
    
    func fetchBooks(searchText: String) -> RxSwift.Observable<BookResult> {
        return provider.rx.request(.getBookInfo(searchText: searchText))
            .filterSuccessfulStatusCodes()
            .map(BookResult.self)
            .asObservable()
    }
}
