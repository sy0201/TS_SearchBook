//
//  BookViewModel.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/30/24.
//

import Foundation
import RxSwift

final class BookViewModel {
    private let repository: BookRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    // View가 구독할 Subject
    let bookSubject = BehaviorSubject(value: [BookModel]())
    
    let nobelBookSubject = BehaviorSubject<[BookModel]>(value: [])
    let searchResultSubject = BehaviorSubject<[BookModel]>(value: [])
    
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let errorMessage: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    
    init(repository: BookRepositoryProtocol) {
        self.repository = repository
        fetchNobel(searchText: "한강")
    }
    
    // ViewModel이 수행해야할 비즈니스 로직
    // 노벨 문학상 가져오기(반드시 검색어가 있어야 해서 노벨 문학상 기준으로 설정)
    func fetchNobel(searchText: String) {
        isLoading.onNext(true)
        
        repository.fetchBooks(searchText: searchText)
            .map { $0.bookModels }
            .subscribe(onNext: { [weak self] books in
                self?.bookSubject.onNext(books)
                print("books \(books)")
            }, onError: { error in
                print("Error fetching books: \(error)")
                // 에러 발생 시 빈 배열 전달
                self.bookSubject.onNext([])
            })
            .disposed(by: disposeBag)
    }
}
