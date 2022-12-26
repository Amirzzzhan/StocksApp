//
//  StocksApi.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 19.12.2022.
//

import Foundation
import Alamofire

typealias StocksApiResponce = (Stock?) -> Void

protocol StocksApiLogic {
    func getCompanyStock(ticker: String, completion: @escaping StocksApiResponce)
}

final class StocksApi: StocksApiLogic {
    
    private struct Constants {
        static let companyQuoteUrl = "https://finnhub.io/api/v1/quote?token=cbb66iaad3i91bfqft00&symbol="
        static let companyProfileUrl = "https://finnhub.io/api/v1/stock/profile2?token=cbb66iaad3i91bfqft00&symbol="
    }
    
    func getCompanyStock(ticker: String, completion: @escaping StocksApiResponce) {
        let stock = Stock()
        var errFound = false
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(Constants.companyProfileUrl + ticker)
            .validate()
            .responseDecodable(of: CompanyProfile.self) { response in
                DispatchQueue.main.async {
                    
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        errFound = true
                    case .success(let companyProfile):
                        stock.ticker = companyProfile.ticker
                        stock.logo = companyProfile.logo
                        stock.name = companyProfile.name
                    }
                    
                    dispatchGroup.leave()
                }
                
            }
        
        dispatchGroup.enter()
        AF.request(Constants.companyQuoteUrl + ticker)
            .validate()
            .responseDecodable(of: CompanyQuote.self) { response in
                DispatchQueue.main.async {
                    
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        errFound = true
                    case .success(let companyQuote):
                        stock.currentPrice = companyQuote.c
                        stock.priceChange = companyQuote.d
                        stock.pricePercentChange = companyQuote.dp
                    }
                    
                    dispatchGroup.leave()
                }
            }
        
        dispatchGroup.notify(queue: .main) {
            errFound ? completion(nil) : completion(stock)
        }
    }
}
