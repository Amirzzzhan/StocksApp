//
//  Stock+CoreDataProperties.swift
//  
//
//  Created by Amirzhan Armandiyev on 23.12.2022.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var currentPrice: Double
    @NSManaged public var priceChange: Double
    @NSManaged public var pricePercentChange: Double
    @NSManaged public var name: String?
    @NSManaged public var logo: String?
    @NSManaged public var ticker: String?

}
