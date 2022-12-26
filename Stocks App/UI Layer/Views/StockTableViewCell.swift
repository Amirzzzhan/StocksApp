//
//  StockTableViewCell.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 26.12.2022.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let padding: CGFloat = 8
        static let imageHeight: CGFloat = 52
    }
    
    // MARK: - UI
    let image: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .red
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    private let tickerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        button.setImage(UIImage(named: "star_empty"), for: .normal)
        button.addTarget(self, action: #selector(starPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Populate UIs
    
    func populate(_ stock: Stock) {
        image.backgroundColor = .red
        tickerLabel.text = stock.ticker
        companyNameLabel.text = stock.name
        priceLabel.text = "$\(stock.currentPrice ?? 0)"
        percentChangeLabel.text = "\(stock.priceChange ?? 0)"
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
    
    @objc func starPressed(_ sender: UIButton!) {
        
    }
    
    private func addSubviews() {
        contentView.addSubview(image)
//        contentView.addSubview(tickerLabel)
//        contentView.addSubview(companyNameLabel)
//        contentView.addSubview(priceLabel)
//        contentView.addSubview(percentChangeLabel)
//        contentView.addSubview(starButton)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate(
            [
//            image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.padding),
             image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
             image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
             image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
             
//             image.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
             
//             tickerLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 12),
//             tickerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
//
//             companyNameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 12),
//             companyNameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor),
//             companyNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
//
//             starButton.leftAnchor.constraint(equalTo: tickerLabel.rightAnchor, constant: 6),
//             starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
//
//             priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -Constants.padding),
//             priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
//
//             percentChangeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -Constants.padding),
//             percentChangeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
//             percentChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor)
             
            ]
        )
    }
}
