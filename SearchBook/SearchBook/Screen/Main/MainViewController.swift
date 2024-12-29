//
//  MainViewController.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit
import RxMoya
import RxSwift
import Moya

// Section Layout 설정
fileprivate enum Section: Hashable {
    case horizontal
    case vertical
}

fileprivate enum Item: Hashable {
    case recentlyPublichedBook  // 최근 출판된 책(date기준으로 가져올 데이터)
    case searchResultBook  // 검색 결과 책
}

final class MainViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // TODO: - Rx로 수정 필요
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
    
    private let mainView = MainView()
    private let provider = MoyaProvider<BookAPI>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchBooks(searchText: "한강")
    }
    
    private func fetchBooks(searchText: String) {
        provider.rx.request(.getBookInfo(searchText: searchText))
            .map(BookResult.self)
            .subscribe { event in
                switch event {
                case .success(let bookResult):
                    print("Fetched books: \(bookResult.bookModels)")
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let response = moyaError.response {
                        print("Response: \(String(data: response.data, encoding: .utf8) ?? "nil")")
                    }
                    print("Error: \(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
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

// MARK: - UICollectionView Method

private extension MainViewController {
    func setupCollectionView() {
        mainView.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        
        mainView.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        mainView.collectionView.register(RecentlyPublishedBookCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyPublishedBookCollectionViewCell.reuseIdentifier)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .horizontal:
                return self?.createHorizontalSection()
                
            case .vertical:
                return self?.createVerticalSection()
                
            default:
                return self?.createVerticalSection()
            }
            
        }, configuration: config)
    }
    
    // 최근 출판된 책 Section Layout
    func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 검색 결과 책 Section Layout
    func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setupDataSource() {
        // cell dataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .recentlyPublichedBook:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPublishedBookCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentlyPublishedBookCollectionViewCell
                return cell
                
            case .searchResultBook:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPublishedBookCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentlyPublishedBookCollectionViewCell
                return cell
            }
        })
        // header dataSource
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath)
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .horizontal, .vertical:
                print("Default")
            default:
                print("Default")
            }
            return header
        }
    }
}
