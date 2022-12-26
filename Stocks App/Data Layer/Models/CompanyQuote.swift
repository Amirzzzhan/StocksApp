//
//  CompanyQuote .swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 19.12.2022.
//

import Foundation

struct CompanyQuote: Decodable {
    let c: Double // current price
    let d: Double // change
    let dp: Double // percent change
}
