//
//  HeaderView.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView, ReuseIdentifying {
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension HeaderView {
    func setupUI() {
        addSubview(titleLabel)
    }
    
    func setupConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
    }
}
