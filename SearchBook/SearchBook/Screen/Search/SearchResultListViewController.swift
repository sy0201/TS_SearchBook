//
//  SearchResultListViewController.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit

final class SearchResultListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

// MARK: - UISearchResultsUpdating Method
extension SearchResultListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print("\(text)")
    }
}
