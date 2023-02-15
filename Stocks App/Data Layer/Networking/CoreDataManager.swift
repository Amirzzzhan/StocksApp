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

    func getSearchedTexts() -> [SearchHistory] {
        let request = NSFetchRequest<SearchHistory>(entityName: "SearchHistory")

        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    private func freeSearchedTexts() {
        let searchedTexts = getSearchedTexts()
        
        if let searchedText = searchedTexts.first {
            deleteSearchedText(text: searchedText)
        }
    }
    
    func addSearchedText(text: String) {
        if getSearchedTexts().count == 14 {
            freeSearchedTexts()
        }
        
        let searchedText = SearchHistory(context: CoreDataManager.shared.viewContext)
        searchedText.text = text
        saveUpdates()
    }
    
    func saveUpdates() {
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
    
    func deleteSearchedText(text: SearchHistory) {
        viewContext.delete(text)
        
        saveChanges()
    }
    
    func clearStorage() {
        for stock in getStocks() {
            deleteStock(stock: stock)
        }
        
        for searchedText in getSearchedTexts() {
            deleteSearchedText(text: searchedText)
        }
        
        saveChanges()
    }

}
