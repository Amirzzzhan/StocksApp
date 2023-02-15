//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by Amirzhan Armandiyev on 14.02.2023.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var text: String?

}
