//
//  HistoricalData.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 08.02.2023.
//

import Foundation

class Initial: Decodable {
    
    let resultsCount: Int
    let results: [HistoricalData]
    
}

class HistoricalData: Decodable {
    
    let c: Double // cost
    let t: Int // time
    
}


