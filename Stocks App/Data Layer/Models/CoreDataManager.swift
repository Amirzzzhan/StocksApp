//
//  CoreDataManager.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 26.12.2022.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            fatalError(error.localizedDescription)
        }
    }
    
    func getFavoriteStocks() -> [FavouriteTicker] {
        let request = NSFetchRequest<FavouriteTicker>(entityName: "FavouriteTicker")
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func addFavoriteStock(ticker: String) {
        let newFavorite = FavouriteTicker(context: viewContext)
        
        newFavorite.ticker = ticker
        
        saveChanges()
    }
    
    func deleteFavoriteStock(ticker: FavouriteTicker) {
        viewContext.delete(ticker)
        
        saveChanges()
    }

}
