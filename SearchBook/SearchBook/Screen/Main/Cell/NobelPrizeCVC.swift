//
//  NobelPrize.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit
import SnapKit
import Kingfisher

final class NobelPrizeCVC: UICollectionViewCell, ReuseIdentifying {
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

private extension NobelPrizeCVC {
    func setupUI() {
        addSubViews([thumbnailImageView,
                     titleLabel,
                     authorLabel])
    }
    
    func setupConstraint() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
}
