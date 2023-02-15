//
//  navigationSearchBarView.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 01.02.2023.
//

import Foundation
import UIKit

final class NavigationSearchBarView: UIView {
    
    private(set) var search: UISearchBar = {
        let search = UISearchBar()
        
        search.translatesAutoresizingMaskIntoConstraints = false
        search.clipsToBounds = true
        search.placeholder = "Find a company or ticker"
        search.layer.borderColor = UIColor.black.cgColor
        search.layer.borderWidth = 1.2
        search.layer.cornerRadius = 22 // 28
        search.setImage(UIImage(named: "Glass"), for: .search, state: .normal)
        search.setImage(UIImage(named: "Cross"), for: .clear, state: .normal)
        search.setPositionAdjustment(UIOffset(horizontal: 15, vertical: 0), for: .search)
        search.setPositionAdjustment(UIOffset(horizontal: -15, vertical: 0), for: .clear)
        search.searchTextPositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
    
        let textfield = search.searchTextField
        textfield.backgroundColor = .white
        textfield.textColor = .black
        
        guard let font = UIFont(name: "Montserrat-SemiBold", size: 16) else { return search }
        textfield.attributedPlaceholder = NSAttributedString(string: "Find a company or ticker", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font])
        
        textfield.font = UIFont.init(name: "Montserrat-SemiBold", size: 16)
        
        //        search.searchTextField.addTarget(self, action: #selector(searchDidBeginEditingAction), for: .editingDidBegin)
        
        return search
    }()
    
    private(set) lazy var leftButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        self.addSubview(search)
        search.addSubview(leftButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                search.leftAnchor.constraint(equalTo: self.leftAnchor),
                search.rightAnchor.constraint(equalTo: self.rightAnchor),
                search.topAnchor.constraint(equalTo: self.topAnchor),
                search.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//                search.heightAnchor.constraint(equalToConstant: 50),
                
                leftButton.leftAnchor.constraint(equalTo: search.leftAnchor, constant: 20),
                leftButton.centerYAnchor.constraint(equalTo: search.centerYAnchor),
                leftButton.heightAnchor.constraint(equalToConstant: 20),
                leftButton.widthAnchor.constraint(equalToConstant: 20)
            ]
        )
        
    }
    
    func setSearchImage(image: String) {
        search.searchTextField.text = "" 
        
        search.setImage(UIImage(named: image), for: .search, state: .normal)
        search.placeholder = "Find a company or ticker"
    }
}
