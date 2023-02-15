//
//  NSObject.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 26.12.2022.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
