//
//  ViewController.swift
//  Stocks App
//
//  Created by Amirzhan Armandiyev on 19.12.2022.
//

import UIKit
import Combine

enum MainViewState {
    case stocks
    case searchHistory
    case searchResults

}

final class ViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 16
    }
    
    private var viewState: MainViewState = .stocks {
        didSet {
            switch viewState {
            case .stocks:
                <#code#>
            case .searchHistory:
                <#code#>
            case .searchResults:
                <#code#>
            }
        }
    }
    
    private let viewModel = StocksViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let navigationBarTitleView = NavigationSearchBarView()
    
    private var searchBarIsEmpty: Bool {
        guard let text = navigationBarTitleView.search.text else { return false }
        
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.className)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68 * 1.15
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    private lazy var stocksButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(stocksButtonAction), for: .touchUpInside)
        
        button.setAttributedTitle(buttonTextStyle(wasSelected: true, buttonText: "Stocks"), for: .normal)
        
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
        
        button.setAttributedTitle(buttonTextStyle(wasSelected: false, buttonText: "Favourite"), for: .normal)
        
        
        return button
    }()
    
    private let searchHistoryView: SearchHistoryView = {
        let arr = ["Apple", "Amazon", "First Solar", "Tesla", "Apple", "AmazonASFASFAS", "Google"]
        let view = SearchHistoryView(searchedCompanies: arr, viewTitle: "Popular requests")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private let popularSearchesView: SearchHistoryView = {
        let arr = ["Apple", "Amazon", "First Solar", "Tesla", "Apple", "AmazonASFASFAS", "Google"]
        let view = SearchHistoryView(searchedCompanies: arr, viewTitle: "You’ve searched for this")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        if let font = UIFont(name: "Montserrat-Bold", size: 20) {
            label.attributedText = NSAttributedString(string: "Stock", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font])
        }
        
        return label
    }()
    
//    private let showMoreButton:
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        
        addSubviews()
        setupTableView()
        setupSearchBar()
        setSubviewConstraints()
        
        setupBinders()
        retrieveStocksData()
    }
    
    private func addSubviews() {
        view.addSubview(stocksButton)
        view.addSubview(favouriteButton)
        view.addSubview(tableView)
        
        
        view.addSubview(searchHistoryView)
        view.addSubview(popularSearchesView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        navigationBarTitleView.search.delegate = self
        
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.titleView = navigationBarTitleView
        
        navigationBarTitleView.search.searchTextField.addTarget(self, action: #selector(searchDidBeginEditingAction), for: .editingDidBegin)
        
        navigationBarTitleView.leftButton.addTarget(self, action: #selector(searchBarLeftButtonPressed), for: .touchUpInside)
        navigationBarTitleView.leftButton.isHidden = true
    }
    
    @objc private func searchBarLeftButtonPressed(sender: UIButton!) {
        if stocksButton.isHidden {
            stocksButton.isHidden = false
            favouriteButton.isHidden = false
            tableView.isHidden = false
            
            searchHistoryView.isHidden = true
            popularSearchesView.isHidden = true
            navigationBarTitleView.leftButton.isHidden = true
        
            navigationBarTitleView.setSearchImage(image: "Glass")
            
            tableView.reloadData()
        }
    }
    
    @objc func searchDidBeginEditingAction(sender: UITextField!) {
        guard let text = sender.text else { return }
        
        if text.isEmpty {
            stocksButton.isHidden = true
            favouriteButton.isHidden = true
            tableView.isHidden = true
            
            searchHistoryView.isHidden = false
            popularSearchesView.isHidden = false
            navigationBarTitleView.leftButton.isHidden = false
        } else {
            tableView.isHidden = false
        }
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
        
        viewModel.$filteredStocks
            .receive(on: RunLoop.main)
            .sink { [weak self] filteredStocks in
                
                self?.tableView.reloadData()
                
            } .store(in: &cancellables)
        
        searchHistoryView.$searchedCompany
            .receive(on: RunLoop.main)
            .sink { [weak self] isButtonPressed in

                self?.tickerButtonPressed(ticker: self?.searchHistoryView.searchedCompany)

            } .store(in: &cancellables)
        
        popularSearchesView.$searchedCompany
            .receive(on: RunLoop.main)
            .sink { [weak self] isButtonPressed in

                self?.tickerButtonPressed(ticker: self?.popularSearchesView.searchedCompany)

            } .store(in: &cancellables)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let mainViewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let navigationBarViewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mainViewTap.cancelsTouchesInView = false
        navigationBarViewTap.cancelsTouchesInView = false
        view.addGestureRecognizer(mainViewTap)
        navigationBarTitleView.addGestureRecognizer(navigationBarViewTap)
    }
    
    @objc func dismissKeyboard() {
        navigationBarTitleView.endEditing(false)
    }
    
    private func tickerButtonPressed(ticker: String?) {
        searchHistoryView.isHidden = true
        popularSearchesView.isHidden = true
    
        guard let ticker = ticker else { return }
        navigationBarTitleView.search.text = ticker
        searchBar(navigationBarTitleView.search, textDidChange: ticker)

        tableView.isHidden = false
    }
    
    @objc func favouriteButtonAction(sender: UIButton!) {
        scrollToTop(isFavouriteScreen: true)
        
        sender.setAttributedTitle(buttonTextStyle(wasSelected: true, buttonText: "Favourite"), for: .normal)
        stocksButton.setAttributedTitle(buttonTextStyle(wasSelected: false, buttonText: "Stocks"), for: .normal)
    }
    
    @objc func stocksButtonAction(sender: UIButton!) {
        scrollToTop(isFavouriteScreen: false)
        
        sender.setAttributedTitle(buttonTextStyle(wasSelected: true, buttonText: "Stocks"), for: .normal)
        favouriteButton.setAttributedTitle(buttonTextStyle(wasSelected: false, buttonText: "Favourite"), for: .normal)
    }
    
    private func buttonTextStyle(wasSelected: Bool, buttonText: String) -> NSAttributedString {
        if wasSelected {
            if let font = UIFont(name: "Montserrat-Bold", size: 28) {
                return NSAttributedString(string: buttonText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font])
            }
        } else {
            if let font = UIFont(name: "Montserrat-Bold", size: 18) {
                let textColor = UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)
                return NSAttributedString(string: buttonText, attributes: [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font])
            }
        }
        return NSAttributedString(string: buttonText)
    }
    
    private func scrollToTop(isFavouriteScreen: Bool) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if tableView.numberOfSections > 0 {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
        
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.viewModel.setIsFavouriteScreen(favouriteScreen: isFavouriteScreen)
            self.retrieveStocksData()
        }
    }
    
    private func setSubviewConstraints() {
        NSLayoutConstraint.activate(
            [
                navigationBarTitleView.widthAnchor.constraint(equalToConstant: 0.90 * view.frame.size.width),

                searchHistoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                searchHistoryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                searchHistoryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                searchHistoryView.heightAnchor.constraint(equalToConstant: (40 * 1.24 * 2 + 24 * 1.24)),
                
                popularSearchesView.topAnchor.constraint(equalTo: searchHistoryView.bottomAnchor, constant: 50),
                popularSearchesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                popularSearchesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                popularSearchesView.heightAnchor.constraint(equalToConstant: (40 * 1.24 * 2 + 24 * 1.24)),

                stocksButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
                stocksButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 23),
                stocksButton.heightAnchor.constraint(equalToConstant: 39.82),
                
                favouriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
                favouriteButton.leftAnchor.constraint(equalTo: stocksButton.rightAnchor, constant: 23),
                favouriteButton.heightAnchor.constraint(equalToConstant: 39.82),
                
                tableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: Constants.spacing),
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tableView.widthAnchor.constraint(equalToConstant: 328 * 1.15),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (isFiltering ? viewModel.filteredStocks.count : viewModel.stocks.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.className, for: indexPath) as! StockTableViewCell
        
        cell.layer.cornerRadius = 16
        let cellBackgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        cell.backgroundColor = (indexPath.section & 1 == 1) ? UIColor.white : cellBackgroundColor
        
        let stocks = (isFiltering ? viewModel.filteredStocks : viewModel.stocks)
        
        cell.populate(stocks[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68 * 1.15
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 ? 0 : 4.48)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = false
        
        searchHistoryView.isHidden = true
        popularSearchesView.isHidden = true
        navigationBarTitleView.leftButton.isHidden = false
        
        viewModel.searchStocks(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "Arrow"), for: .search, state: .normal)
        searchBar.placeholder = ""
    }
}
