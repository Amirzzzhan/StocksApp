//
//  FavouriteTicker+CoreDataProperties.swift
//  
//
//  Created by Amirzhan Armandiyev on 26.12.2022.
//
//

import Foundation
import CoreData


extension FavouriteTicker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteTicker> {
        return NSFetchRequest<FavouriteTicker>(entityName: "FavouriteTicker")
    }

    @NSManaged public var ticker: String?

}
