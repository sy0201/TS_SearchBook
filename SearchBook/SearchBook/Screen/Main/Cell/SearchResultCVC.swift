//
//  SearchResultCVC.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/30/24.
//

import UIKit
import Kingfisher

final class SearchResultCVC: UICollectionViewCell, ReuseIdentifying {
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return authorLabel
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(thumbnailImage: String, title: String, author: String) {
        thumbnailImageView.kf.setImage(with: URL(string: thumbnailImage))
        titleLabel.text = title
        authorLabel.text = author
    }
}

private extension SearchResultCVC {
    func setupUI() {
        addSubViews([thumbnailImageView,
                     titleLabel,
                     authorLabel])
    }
    
    func setupConstraint() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.top.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}
