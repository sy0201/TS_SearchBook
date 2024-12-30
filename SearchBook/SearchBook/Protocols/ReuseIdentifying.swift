//
//  ReuseIdentifying.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import Foundation

protocol ReuseIdentifying: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
