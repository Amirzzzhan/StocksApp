//
//  SearchHistoryView.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 25.01.2023.
//

import Foundation
import Combine
import UIKit

protocol SearchHistoryViewProtocol: AnyObject {
    func didTapOnButton(text: String)
}

final class SearchHistoryView: UIView {

    weak var delegate: SearchHistoryViewProtocol?
    
    private var viewTitle: String = ""
    private var searchedCompanies: [String?] = []
    
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
    
    convenience init(viewTitle: String) {
        self.init(frame: .zero)
        self.viewTitle = viewTitle
        
        setupView()
        setupConstraints()
        setLabelTitle(text: viewTitle)
        setupStacks()
    }
    
    
    public func addToStack() {
        
        verticalStack.removeFullyAllArrangedSubviews()
        firstStack.removeFullyAllArrangedSubviews()
        secondStack.removeFullyAllArrangedSubviews()
        
        setupStacks()
    }
    
    private func setupStacks() {
        
        if viewTitle == "You’ve searched for this" {
            searchedCompanies = CoreDataManager.shared.getSearchedTexts().map { $0.text }
        } else {
            searchedCompanies = ["Apple", "Amazon", "First Solar", "Tesla", "Intel", "AMD", "Google",
                       "Meta", "Alibaba", "Facebook", "Yandex", "Visa", "GM", "Nokia"]
        }
        
        for (index, text) in searchedCompanies.enumerated() {
            guard let text = text else { continue }
            
            let butt = createButton(title: text)
            
            if index < 7 {
                firstStack.addArrangedSubview(butt)
            } else {
                secondStack.addArrangedSubview(butt)
            }
        }
        
        verticalStack.addArrangedSubview(firstStack)
        verticalStack.addArrangedSubview(secondStack)
        
        let inset: CGFloat = 40
        verticalStack.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor, constant: -inset * 2).isActive = true
    }
    
    private func createButton(title: String) -> UIButton {
        let butt = UIButton(configuration: UIButton.Configuration.outline())
        
        butt.addTarget(self, action: #selector(tickerButtonPressed), for: .touchUpInside)
        
        if let font = UIFont(name: "Montserrat-SemiBold", size: 15) {
            butt.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font]), for: .normal)
        }
        
        butt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return butt
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
            delegate?.didTapOnButton(text: ticker)
        }
    }
}
