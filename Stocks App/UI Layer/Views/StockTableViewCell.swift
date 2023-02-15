//
//  StockTableViewCell.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 26.12.2022.
//

import UIKit
import SDWebImageSVGNativeCoder

class StockTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let padding: CGFloat = 9.96
        static let imageHeight: CGFloat = 64.7
    }
    
    private var currentCellStock: Stock?
    
    // MARK: - UI
    private let image: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    private let tickerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.backgroundColor = .yellow
        
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .red
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let percentChangeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Empty Star"), for: .normal)
        button.addTarget(self, action: #selector(starPressed), for: .touchUpInside)
        
//        button.backgroundColor = .red
        
        return button
    }()
    
    // MARK: - Populate UIs
    
    func populate(_ stock: Stock) {
        
        currentCellStock = stock
        
        guard let ticker = stock.ticker,
              let name = stock.name,
              let logo = stock.logo else { return }
        
        let currentPrice = stock.currentPrice
        let priceChange = stock.priceChange
        let percent = stock.pricePercentChange
        
        if let font = UIFont(name: "Montserrat-Bold", size: 18) {
            let textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            
            tickerLabel.attributedText = NSAttributedString(string: ticker, attributes: [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font])
            
            priceLabel.attributedText = NSAttributedString(string: "$\(currentPrice)", attributes: [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font])
        }

        if let font = UIFont(name: "Montserrat-SemiBold", size: 14) {
            let textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            let textColorDecline = UIColor(red: 0.7, green: 0.14, blue: 0.14, alpha: 1)
            let textColorIncrease = UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1)
            
            companyNameLabel.attributedText = NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font])
            
            if priceChange < 0 {
                percentChangeLabel.attributedText = NSAttributedString(string: "-$\(-priceChange) (\(String(format: "%.2f", percent))%)", attributes: [NSAttributedString.Key.foregroundColor: textColorDecline, NSAttributedString.Key.font: font])
            } else {
                percentChangeLabel.attributedText = NSAttributedString(string: "+$\(priceChange) (\(String(format: "%.2f", percent))%)", attributes: [NSAttributedString.Key.foregroundColor: textColorIncrease, NSAttributedString.Key.font: font])
            }
           
        }
        
        image.sd_setImage(with: URL(string: logo))
        
        let starImage = stock.isFavourite ? UIImage(named: "Filled Star") : UIImage(named: "Empty Star")
        starButton.setImage(starImage, for: .normal)
    }
    
    // MARK: - Lifecycle
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Star Pressed
    @objc func starPressed(_ sender: UIButton!) {
        guard let currentCellStock = currentCellStock else { return }
        
        let starImage = currentCellStock.isFavourite ? UIImage(named: "Empty Star") : UIImage(named: "Filled Star")
        sender.setImage(starImage, for: .normal)
        
        if currentCellStock.isFavourite {
            CoreDataManager.shared.deleteFavoriteStock(stock: currentCellStock)
        } else {
            CoreDataManager.shared.addFavoriteStock(stock: currentCellStock)
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(image)
        contentView.addSubview(tickerLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(percentChangeLabel)
        contentView.addSubview(starButton)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate(
            [
                image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.padding * 1.15),
                image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                image.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
                image.widthAnchor.constraint(equalToConstant: Constants.imageHeight),
                
                tickerLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 12 * 1.15),
                tickerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14 * 1.24),
                
                companyNameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 12 * 1.15),
                companyNameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor),
                companyNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14 * 1.24),
                
                starButton.leftAnchor.constraint(equalTo: tickerLabel.rightAnchor, constant: 6 * 1.15),
                starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 * 1.24),
                starButton.heightAnchor.constraint(equalToConstant: 16 * 1.24),
                starButton.widthAnchor.constraint(equalToConstant: 16 * 1.15),
                
                priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.padding * 1.15),
                priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14 * 1.24),
                
                percentChangeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.padding * 1.15),
                percentChangeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14 * 1.24),
                percentChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor)
                
            ]
        )
    }
}
