//
//  Searched+CoreDataProperties.swift
//  
//
//  Created by Amirzhan Armandiyev on 14.02.2023.
//
//

import Foundation
import CoreData


extension Searched {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Searched> {
        return NSFetchRequest<Searched>(entityName: "Searched")
    }

    @NSManaged public var text: String?

}
