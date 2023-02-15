//
//  UIBarButtonItem.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 07.02.2023.
//

import Foundation
import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        
        var image = UIImage(named: imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true

        return menuBarItem
    }
    
}
