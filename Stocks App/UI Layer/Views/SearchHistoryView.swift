//
//  SearchHistoryView.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 25.01.2023.
//

import Foundation
import Combine
import UIKit

final class SearchHistoryView: UIView {
    
    private var searchedCompanies: [String]?
    @Published private(set) var searchedCompany: String = ""
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        
        return scrollView
    }()
    
    private let firstStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 6
        
        return stack
    }()
    
    private let secondStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 6

        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        return stack
    }()
    
    convenience init(searchedCompanies: [String], viewTitle: String) {
        self.init(frame: .zero)
        self.searchedCompanies = searchedCompanies
        
        setupView()
        setupConstraints()
        setLabelTitle(text: viewTitle)
        
        
        let arr = ["Apple", "Amazon", "First Solar", "Tesla", "Apple", "AmazonASFASFAS", "Google"]
        
        for i in arr {
            let butt = UIButton(configuration: UIButton.Configuration.outline())
            
            butt.addTarget(self, action: #selector(tickerButtonPressed), for: .touchUpInside)
            
            if let font = UIFont(name: "Montserrat-SemiBold", size: 15) {
                butt.setAttributedTitle(NSAttributedString(string: i, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font]), for: .normal)
            }
            
            butt.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            firstStack.addArrangedSubview(butt)
            
        }
        
        let arr1 = ["First Solar", "Amazon", "Facebook", "Tesla", "Apple", "AmazonASFASFAS", "Google"]
        for i in arr1 {
            let butt = UIButton(configuration: UIButton.Configuration.outline())
            
            butt.addTarget(self, action: #selector(tickerButtonPressed), for: .touchUpInside)
            
            if let font = UIFont(name: "Montserrat-SemiBold", size: 15) {
                butt.setAttributedTitle(NSAttributedString(string: i, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font]), for: .normal)
            }
            
            butt.heightAnchor.constraint(equalToConstant: 50).isActive = true
            secondStack.addArrangedSubview(butt)
        }
        
        
        verticalStack.addArrangedSubview(firstStack)
        verticalStack.addArrangedSubview(secondStack)
        
        let inset:CGFloat = 40
        verticalStack.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor, constant: -inset*2).isActive = true
        
    }
    
    private func setLabelTitle(text: String) {
        if let font = UIFont(name: "Montserrat-Bold", size: 20) {
            label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font])
        }
    }
    
    private func setupView() {
        self.addSubview(scrollView)
        
        self.addSubview(label)
        scrollView.addSubview(verticalStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.leftAnchor.constraint(equalTo: self.leftAnchor),
                label.heightAnchor.constraint(equalToConstant: 24 * 1.24),
                
                scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
//                scrollView.heightAnchor.constraint(equalToConstant: 100),
                
                verticalStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
                verticalStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
                verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
                verticalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                verticalStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ]
        )
    }
    
    @objc private func tickerButtonPressed(sender: UIButton!) {
        if let ticker = sender.currentAttributedTitle?.string {
            searchedCompany = ticker
//            didTap(ticker)
        }
    }
}
