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
    
    private let tickers: [String] = ["AAPL", "AMZN", "MSFT", "GOOGL", "META", "UNH", "JNJ", "JPM", "V", "PG","XOM","HD", "CVX", "ABBV", "PFE", "AVGO", "COST", "DIS", "ABEV", "F", "CCL", "NIO", "TSLA", "COIN"]
    
    private var isFavouriteScreen: Bool = false
    
    @Published private(set) var stocks: [Stock] = []
    
    private let api: StocksApiLogic
    
    init(apiService: StocksApiLogic = StocksApi()) {
        self.api = apiService
    }
    
    func setIsFavouriteScreen(favouriteScreen: Bool) {
        self.isFavouriteScreen = favouriteScreen
    }
    
    func getStocks() {
        var stockDictionary = [String : Stock]()
        
        let group = DispatchGroup()
        
        if isFavouriteScreen {
            let tickersArr = CoreDataManager.shared.getFavoriteStocks()
            for favouriteStock in tickersArr {
                guard let ticker = favouriteStock.ticker else { return }
                group.enter()
                self.api.getCompanyStock(ticker: ticker) { stock in
                    if let stock = stock, let ticker = stock.ticker {
                        stockDictionary[ticker] = stock
                        group.leave()
                    }
                }
            }
        } else {
            for ticker in tickers {
                group.enter()
                self.api.getCompanyStock(ticker: ticker) { stock in
                    if let stock = stock, let ticker = stock.ticker {
                        stockDictionary[ticker] = stock
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.stocks = []
            for ticker in self.tickers {
                if let stock = stockDictionary[ticker] {
                    self.stocks.append(stock)
                }
            }
        }
    }
    
}
