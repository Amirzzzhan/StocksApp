//
//  InfoPageVC.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 02.02.2023.
//

import UIKit
import Combine
import SwiftChart


//enum MonsterratFontType: String {
//    case bold = "Montserrat-Bold"
//    case semibold = "Montserrat-SemiBold"
//}

final class InfoPageVC: UIViewController {
    
    // MARK: - Private Attributes
    
    private let stock: Stock
    private let viewModel: StocksViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UIs
    
    private let chart: Chart = {
        let chart = Chart()
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.clearsContextBeforeDrawing = true
        chart.showXLabelsAndGrid = false
        chart.showYLabelsAndGrid = false
        chart.highlightLineColor = .black
        chart.lineWidth = 2
        chart.areaAlphaComponent = 0.05
        
        return chart
    }()
    
    private let titleTextStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4 * 1.24
        
        return stack
    }()
    
    private lazy var chartLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = textStyle(text: "Chart", size: 20, font: "Montserrat-Bold")
        label.textAlignment = .center
        
        return label
    }()
    
    private let line: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var buttonsArray: [UIButton] = []
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10 * 1.15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(stock: Stock, viewModel: StocksViewModel) {
        self.stock = stock
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupButtons()
        setupChart()
        setupLabels()
        
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Chart Setup
    
    private func setupChart() {
        chart.delegate = self
        
        // Binder
        viewModel.$historicalData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                
                self?.populateChart()
                
            } .store(in: &cancellables)
        
        if let ticker = stock.ticker {
            viewModel.getPriceHistory(ticker: ticker, range: "2Y")
        }
    }
    
    private func populateChart() {
        var data: [(x: Double, y: Double)] = []
        
        for pair in viewModel.historicalData {
            data.append((x: Double(pair.t), y: pair.c))
        }
        data.append((x: NSDate().timeIntervalSince1970 * 1000, y: stock.currentPrice))
        
        let series = ChartSeries(data: data)
        
        series.color = .black
        series.area = true
        chart.removeAllSeries()
        chart.add(series)
    }
    
    // MARK: - Navigation Bar Setup
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        
        if let ticker = stock.ticker, let company = stock.name {
            let companyLabel = UILabel()
            companyLabel.attributedText = textStyle(text: company, size: 14, font: "Montserrat-SemiBold")
            
            let tickerLabel = UILabel()
            tickerLabel.attributedText = textStyle(text: ticker, size: 20, font: "Montserrat-Bold")
            
            titleTextStack.addArrangedSubview(tickerLabel)
            titleTextStack.addArrangedSubview(companyLabel)
            
            navigationItem.titleView = titleTextStack
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(backButtonPressed), imageName: "Arrow")
        
        setRightStar(isFilled: stock.isFavourite)
    }
    
    // MARK: - Labels Setup
    
    private func setupLabels() {
        priceLabel.attributedText = textStyle(text: "$\(stock.currentPrice)", size: 30, font: "Montserrat-Bold")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateLabel.attributedText = textStyle(text: dateFormatter.string(from: Date()), size: 14, font: "Montserrat-Bold", color: UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1))
    }
    
    // MARK: - Buttons Setup
    
    private func setupButtons() {
        let buttonTitle = ["D", "W", "M", "6M", "1Y", "2Y"]
        
        for title in buttonTitle {
            
            let button = UIButton(configuration: UIButton.Configuration.outline())
            
            button.addTarget(self, action: #selector(chartRangePressed), for: .touchUpInside)
            button.setAttributedTitle(textStyle(text: title, size: 14, font: "Montserrat-SemiBold"), for: .normal)
            
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            buttonsStack.addArrangedSubview(button)
            
            buttonsArray.append(button)
        }
        
        if let button = buttonsArray.last {
            button.configuration = UIButton.Configuration.outline(backgroundColor: UIColor.black)
            button.setAttributedTitle(textStyle(text: "2Y", size: 14, font: "Montserrat-SemiBold", color: .white), for: .normal)
        }
        
        buyButton.setAttributedTitle(textStyle(text: "Buy for $\(stock.currentPrice)", size: 18, font: "Montserrat-SemiBold", color: .white), for: .normal)
    }
    
    // MARK: - Button Actions
    
    @objc
    private func starButtonPressed() {
        if stock.isFavourite {
            stock.isFavourite = false
        } else {
            stock.isFavourite = true
        }
        
        setRightStar(isFilled: stock.isFavourite)
        CoreDataManager.shared.saveUpdates()
    }
    
    @objc
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func buyButtonPressed() {
        let alert = UIAlertController(title: "You bought stock", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func chartRangePressed(sender: UIButton!) {
        setupLabels()
        for button in buttonsArray {
            button.configuration = UIButton.Configuration.outline()
            if let text = button.currentAttributedTitle?.string {
                button.setAttributedTitle(textStyle(text: text, size: 14, font: "Montserrat-SemiBold"), for: .normal)
            }
        }
        
        sender.configuration = UIButton.Configuration.outline(backgroundColor: .black)
        if let text = sender.currentAttributedTitle?.string,
           let ticker = stock.ticker {
            
            sender.setAttributedTitle(textStyle(text: text, size: 14, font: "Montserrat-SemiBold", color: .white), for: .normal)
            viewModel.getPriceHistory(ticker: ticker, range: text)
            
        }
    }
    
    // MARK: - Adding Subviews
    
    private func addSubviews() {
        view.addSubview(chartLabel)
        view.addSubview(line)
        view.addSubview(buttonsStack)
        view.addSubview(buyButton)
        view.addSubview(chart)
        view.addSubview(priceLabel)
        view.addSubview(dateLabel)
    }
    
    // MARK: - Constraints Setup
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                chartLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
                chartLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
                chartLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
                chartLabel.heightAnchor.constraint(equalToConstant: 24 * 1.24),
                
                line.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: 10),
                line.leftAnchor.constraint(equalTo: view.leftAnchor),
                line.rightAnchor.constraint(equalTo: view.rightAnchor),
                line.heightAnchor.constraint(equalToConstant: 2),
                
                priceLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 50),
                priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
                priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
                priceLabel.heightAnchor.constraint(equalToConstant: 35),
                
                dateLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
                dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
                dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
                dateLabel.heightAnchor.constraint(equalToConstant: 20),
                
                chart.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
                chart.leftAnchor.constraint(equalTo: view.leftAnchor),
                chart.rightAnchor.constraint(equalTo: view.rightAnchor),
                chart.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor),
                chart.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
                
                buttonsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
                buttonsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23),
                buttonsStack.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -45),
                buttonsStack.heightAnchor.constraint(equalToConstant: 50),
                
                buyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
                buyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23),
                buyButton.heightAnchor.constraint(equalToConstant: 65),
                buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
}


// MARK: - ChartDelegate

extension InfoPageVC: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
                
                let date = Date(timeIntervalSince1970: x / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateStyle = .medium

                if let val = value {
                    priceLabel.attributedText = textStyle(text: String(format: "$%.2f", val), size: 30, font: "Montserrat-Bold")
                }
                dateLabel.attributedText = textStyle(text: dateFormatter.string(from: date), size: 14, font: "Montserrat-Bold", color: UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1))
                
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) { }
    
    func didEndTouchingChart(_ chart: Chart) { }
}

// MARK: - Additional Functions

extension InfoPageVC {
    
    private func setRightStar(isFilled: Bool) {
        let imageName = (isFilled ? "Filled Star" : "Empty Star")
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(starButtonPressed), imageName: imageName)
    }
    
    private func textStyle(text: String, size: CGFloat, font: String, color: UIColor = .black) -> NSAttributedString {
        if let font = UIFont(name: font, size: size) {
            return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        }
        return NSAttributedString(string: "")
    }
    
}
