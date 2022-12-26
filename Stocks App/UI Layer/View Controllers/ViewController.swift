//
//  ViewController.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 19.12.2022.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 16
    }
    
    private let viewModel = StocksViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.className)
        tableView.separatorInset.left = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        
        return tableView
    }()
    
    private let search: UISearchBar = {
        let search = UISearchBar()
        
        search.translatesAutoresizingMaskIntoConstraints = false
        search.text = "Find a company or ticker"
        
        return search
    }()
    
    private lazy var stocksButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(stocksButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        setupTableView()
        setSubviewConstraints()
        
        setupBinders()
        retrieveStocksData()

    }
    
    @objc func favouriteButtonAction(sender: UIButton!) {
        viewModel.setIsFavouriteScreen(favouriteScreen: true)
        retrieveStocksData()
    }
    
    @objc func stocksButtonAction(sender: UIButton!) {
        viewModel.setIsFavouriteScreen(favouriteScreen: false)
        retrieveStocksData()
    }
    
    private func addSubviews() {
        view.addSubview(search)
        view.addSubview(stocksButton)
        view.addSubview(favouriteButton)
        view.addSubview(tableView)
    }
    
    private func setSubviewConstraints() {
        NSLayoutConstraint.activate(
            [search.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             search.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.spacing),
             search.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.spacing),
             
             stocksButton.topAnchor.constraint(equalTo: search.bottomAnchor, constant: Constants.spacing),
             stocksButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.spacing),
             stocksButton.heightAnchor.constraint(equalToConstant: 50),
             stocksButton.widthAnchor.constraint(equalToConstant: 100),
             
             favouriteButton.topAnchor.constraint(equalTo: search.bottomAnchor, constant: Constants.spacing),
             favouriteButton.leftAnchor.constraint(equalTo: stocksButton.rightAnchor, constant: Constants.spacing),
             favouriteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.spacing),
             favouriteButton.heightAnchor.constraint(equalToConstant: 50),
             
             tableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: Constants.spacing),
             tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.spacing),
             tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.spacing),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
             
            ]
        )
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func retrieveStocksData() {
        viewModel.getStocks()
    }
    
    private func setupBinders() {
        viewModel.$stocks
            .receive(on: RunLoop.main)
            .sink { [weak self] stocks in
                
                self?.tableView.reloadData()
                
            } .store(in: &cancellables)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.className, for: indexPath) as! StockTableViewCell
        
        cell.populate(viewModel.stocks[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CoreDataManager.shared.addFavoriteStock(ticker: viewModel.stocks[indexPath.row].ticker ?? "AAPL")
    }
}

