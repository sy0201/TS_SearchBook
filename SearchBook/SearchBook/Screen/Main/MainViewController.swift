//
//  MainViewController.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// Section Layout 설정
fileprivate enum Section: Hashable {
    case horizontal(String)
    case vertical(String)
}

fileprivate enum Item: Hashable {
    case nobelResultBook(BookModel)  // 노벨 문학상 데이터
    case searchResultBook(BookModel)  // 검색 결과 책
}

final class MainViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
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
        return viewController
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(NobelPrizeCVC.self, forCellWithReuseIdentifier: NobelPrizeCVC.reuseIdentifier)
        return collectionView
    }()
    private let viewModel: BookViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: BookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupDataSource()
        bindViewModel()
    }
}

// MARK: - Private Method

private extension MainViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "책 검색"
        navigationItem.searchController = searchController
    }
    
    func bindViewModel() {
        viewModel.nobelBookSubject
            .observe(on: MainScheduler.instance)
            .bind { [weak self] books in
                self?.updateSnapshot(with: books)
                print("받은 도서 개수: \(books.count)")
            }
            .disposed(by: disposeBag)
    }
    
    func updateSnapshot(with books: [BookModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.horizontal("노벨 문학상 에디션"), .vertical("검색 결과")])
        
        // 최근 출판된 책 필터링
        let recentlyPublishedBooks = books
            .map { Item.nobelResultBook($0) }
        
        let searchResultBooks = books
            .prefix(5)
            .map { Item.searchResultBook($0) }
        
        snapshot.appendItems(recentlyPublishedBooks, toSection: .horizontal("노벨 문학상 에디션"))
        snapshot.appendItems(searchResultBooks, toSection: .vertical("검색 결과"))
        
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        // cell dataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            print("item:", item)
            switch item {
            case .nobelResultBook(let bookInfo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NobelPrizeCVC.reuseIdentifier, for: indexPath) as? NobelPrizeCVC
                
                cell?.configure(thumbnailImage: bookInfo.thumbnail ?? "", title: bookInfo.title ?? "", author: bookInfo.authors?[0] ?? "")
                return cell
                
            case .searchResultBook:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NobelPrizeCVC.reuseIdentifier, for: indexPath) as? NobelPrizeCVC
                return cell
            }
        })
        
        // header dataSource
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath)
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .horizontal(let title), .vertical(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                print("Default")
            }
            return header
        }
    }
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UI Method

private extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        print("Creating collection view layout")
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
    
    // 노벨 문학상 Section Layout
    func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(190))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
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
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
