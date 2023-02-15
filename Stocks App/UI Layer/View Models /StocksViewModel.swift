//
//  StocksViewModel.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 21.12.2022.
//

import Foundation
import Combine
import UIKit

final class StocksViewModel: ObservableObject {
    
    private let tickers: [String] = ["AAPL", "AMZN", "MSFT", "GOOGL", "META", "UNH", "JNJ", "JPM", "V", "PG","XOM","HD", "CVX", "ABBV", "PFE", "AVGO", "COST", "DIS", "F", "CCL", "NIO", "TSLA", "COIN"]
    
    private var isFavouriteScreen: Bool = false
    
    @Published private(set) var stocks: [Stock] = []
    
    @Published private(set) var filteredStocks: [Stock] = []
    
    @Published private(set) var historicalData: [HistoricalData] = []
    
    private let api: StocksApiLogic
    
    init(apiService: StocksApiLogic = StocksApi()) {
        self.api = apiService
    }
    
    func setIsFavouriteScreen(favouriteScreen: Bool) {
        self.isFavouriteScreen = favouriteScreen
    }
    
    func searchStocks(text: String) {
        filteredStocks = stocks.filter({ (stock: Stock) -> Bool in
            guard let ticker = stock.ticker, let companyName = stock.name else {
                return false
            }
            
            return (ticker.lowercased().contains(text.lowercased()) ||
                    companyName.lowercased().contains(text.lowercased()))
        })
        
    }
    
    func getPriceHistory(ticker: String, range: String) {
        api.getHistoricalData(ticker: ticker, range: range) { result in
            switch result {
                
            case .success(let priceHistory):
                
                if let priceHistory = priceHistory {
                    self.historicalData = priceHistory
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getStocks() {
        var stockDictionary = [String : Stock]()
        
        let group = DispatchGroup()
        
        for ticker in tickers {
            
            if let stock = CoreDataManager.shared.isStockExists(ticker: ticker) {
                stockDictionary[ticker] = stock
                continue
            }
            
            group.enter()
            self.api.getCompanyStock(ticker: ticker) { stock in
                if let stock = stock, let ticker = stock.ticker {
                    stockDictionary[ticker] = stock
                    group.leave()
                }
            }
        }
        
        
        group.notify(queue: .main) {
            self.stocks = []
            for ticker in self.tickers {
                if let stock = stockDictionary[ticker] {
                    
                    if self.isFavouriteScreen && !stock.isFavourite {
                        continue
                    }
                    
                    self.stocks.append(stock)
                }
            }
            
            //            if isFiltering {
            //                guard let text = text else { return }
            //                self.searchStocks(text: text)
            //            }
        }
        
    }
    
}
