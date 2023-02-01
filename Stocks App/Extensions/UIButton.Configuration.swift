//
//  UIButton.Configuration.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 25.01.2023.
//

import Foundation
import UIKit

extension UIButton.Configuration {
    public static func outline() -> UIButton.Configuration {
        
        var style = UIButton.Configuration.plain()
        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 23
        background.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        style.background = background
                
        return style
        
    }
}
