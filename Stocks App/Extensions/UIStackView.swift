//
//  UIStackView.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 15.02.2023.
//

import Foundation
import UIKit

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}
