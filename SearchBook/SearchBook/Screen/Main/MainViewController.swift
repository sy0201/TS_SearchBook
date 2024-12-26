//
//  MainViewController.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit

final class MainViewController: UIViewController {
    lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: searchResultListVC)
        searchController.searchResultsUpdater = searchResultListVC  // 사용자가 입력한 검색어 업데이트할 대상 설정(현재 searchResultListVC가 업데이트 대상)
        searchController.obscuresBackgroundDuringPresentation = false  // 검색바 활성화시 화면 배경 검정 방지
        searchController.definesPresentationContext = false  // 다른 VC로 이동시 searchController 해제
        
        searchController.searchBar.placeholder = "책 제목, 작가로 검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        return searchController
    }()
    
    lazy var searchResultListVC: SearchResultListViewController = {
        let viewController = SearchResultListViewController()
        // TODO: - Rx로 데이터 전달
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

// MARK: - Private Method

private extension MainViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "책 검색"
        navigationItem.searchController = searchController
    }
}
