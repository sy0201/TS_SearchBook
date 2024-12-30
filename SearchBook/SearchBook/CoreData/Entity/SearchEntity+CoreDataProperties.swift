//
//  SearchEntity+CoreDataProperties.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/30/24.
//
//

import Foundation
import CoreData


extension SearchEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchEntity> {
        return NSFetchRequest<SearchEntity>(entityName: "SearchEntity")
    }

    @NSManaged public var searchText: String?
    @NSManaged public var id: UUID?

}

extension SearchEntity : Identifiable {

}
