//
//  MainView.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit

final class MainView: UIView {
    lazy var collectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainView {
    func setupUI() {
        
    }
}
