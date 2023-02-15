//
//  StocksApi.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 19.12.2022.
//

import Foundation
import Alamofire

typealias StocksApiResponce = (Stock?) -> Void
typealias HistoricalDataResponce = (Swift.Result<[HistoricalData]?, Error>) -> Void

protocol StocksApiLogic {
    func getCompanyStock(ticker: String, completion: @escaping StocksApiResponce)
    func getHistoricalData(ticker: String, range: String, completion: @escaping HistoricalDataResponce)
}

final class StocksApi: StocksApiLogic {
    
    private struct Constants {
        static let companyQuoteUrl = "https://finnhub.io/api/v1/quote?token=cbb66iaad3i91bfqft00&symbol="
        static let companyProfileUrl = "https://finnhub.io/api/v1/stock/profile2?token=cbb66iaad3i91bfqft00&symbol="
        static let historicalDataUrl = "https://api.polygon.io/v2/aggs/ticker/"
        static let historicalDataApiKey = "?apiKey=m1C0qE3uAVy7k3S4zbhY3pn7fk4XYK4X"
    }
    
    func getHistoricalData(ticker: String, range: String, completion: @escaping HistoricalDataResponce) {
        var urlString = Constants.historicalDataUrl + ticker + "/range/1/"
        
        switch range {
        case "D":
            urlString += "minute/"
        case "W":
            urlString += "hour/"
        case "M":
            urlString += "day/"
        case "6M":
            urlString += "week/"
        case "1Y":
            urlString += "month/"
        default:
            urlString += "month/"
        }
        
        urlString += dateFinder(range: range) + "/" + dateFormatter(date: Date())
        urlString += Constants.historicalDataApiKey
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: Initial.self) { responce in
                DispatchQueue.main.async {
                    
                    switch responce.result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let responce):
                        completion(.success(responce.results))
                    }
                    
                }
            }
        
        
    }
    
    func getCompanyStock(ticker: String, completion: @escaping StocksApiResponce) {
        let stock = Stock(context: CoreDataManager.shared.viewContext)
        stock.isFavourite = false
        var err: Error?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(Constants.companyProfileUrl + ticker)
            .validate()
            .responseDecodable(of: CompanyProfile.self) { response in
                DispatchQueue.main.async {
                    
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        err = error
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
                        err = error
                    case .success(let companyQuote):
                        stock.currentPrice = companyQuote.c
                        stock.priceChange = companyQuote.d
                        stock.pricePercentChange = companyQuote.dp
                    }
                    
                    dispatchGroup.leave()
                }
            }
        
        dispatchGroup.notify(queue: .main) {
            CoreDataManager.shared.saveUpdates()
            if let err = err {
                fatalError(err.localizedDescription)
            } else {
                completion(stock)
            }
        }
    }
    
}

// MARK: - Private Helper Functions

extension StocksApi {
    private func dateFinder(range: String) -> String {
        var dayComponent = DateComponents()
        
        switch range {
        case "D":
            dayComponent.day = -3
        case "W":
            dayComponent.day = -7
        case "M":
            dayComponent.month = -1
        case "6M":
            dayComponent.month = -6
        case "1Y":
            dayComponent.year = -1
        default:
            dayComponent.year = -2
        }
        
        let startDate = Calendar.current.date(byAdding: dayComponent, to: Date())
        
        return dateFormatter(date: startDate)
    }
    
    private func dateFormatter(date: Date?) -> String {
        guard let date = date else { return ""}
        
        var ans = ""
        
        for i in date.description {
            if i == " " {
                break
            }
            ans.append(i)
        }
        
        return ans
    }
}
