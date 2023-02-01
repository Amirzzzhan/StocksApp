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
    
    private func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            fatalError(error.localizedDescription)
        }
    }
    
    func getStocks() -> [Stock] {
        let request = NSFetchRequest<Stock>(entityName: "Stock")
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func addStock(stock: Stock) {
        saveChanges()
    }
    
    func isStockExists(ticker: String) -> Stock? {
        let stocks = getStocks()
        
        for stock in stocks {
            if stock.ticker == ticker {
               return stock
            }
        }
        
        return nil
    }
    
    func addFavoriteStock(stock: Stock) {
        stock.isFavourite = true
        
        saveChanges()
    }
    
    func deleteFavoriteStock(stock: Stock) {
        stock.isFavourite = false

        saveChanges()
    }
    
    func deleteStock(stock: Stock) {
        viewContext.delete(stock)
        
        saveChanges()
    }

}
