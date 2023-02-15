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

final class MainVC: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 16
    }
    
    // MARK: - View States
    private var viewState: MainViewState = .stocks {
        didSet {
            switch viewState {
            case .stocks:
                tableView.isHidden = false
                stocksButton.isHidden = false
                favouriteButton.isHidden = false
                searchHistoryView.isHidden = true
                popularSearchesView.isHidden = true
                stocksLabel.isHidden = true
                showMoreButton.isHidden = true
            case .searchHistory:
                tableView.isHidden = true
                stocksButton.isHidden = true
                favouriteButton.isHidden = true
                searchHistoryView.isHidden = false
                popularSearchesView.isHidden = false
                stocksLabel.isHidden = true
                showMoreButton.isHidden = true
            case .searchResults:
                tableView.isHidden = false
                stocksButton.isHidden = true
                favouriteButton.isHidden = true
                searchHistoryView.isHidden = true
                popularSearchesView.isHidden = true
                stocksLabel.isHidden = false
                showMoreButton.isHidden = false
            }
        }
    }
    // MARK: - Private Attributes
    
    private let viewModel = StocksViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Search Bar Logic
    private var searchBarIsEmpty: Bool {
        guard let text = navigationBarTitleView.search.text else { return false }
        
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    // MARK: - UIs
    
    private let navigationBarTitleView = NavigationSearchBarView()
    
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
    
    private let stocksButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentVerticalAlignment = .bottom
        
        return button
    }()
    
    private let popularSearchesView: SearchHistoryView = {
        let view = SearchHistoryView(viewTitle: "Popular requests")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchHistoryView: SearchHistoryView = {
        let view = SearchHistoryView(viewTitle: "You’ve searched for this")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stocksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        
        addSubviews()
        setupTableView()
        setupSearchBar()
        setupButtons()
        setupHistoryViews()
        setSubviewConstraints()
        
        setupBinders()
        retrieveStocksData()
        
        viewState = .stocks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tableView.reloadData()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: - Adding Subviews
    
    private func addSubviews() {
        view.addSubview(stocksButton)
        view.addSubview(favouriteButton)
        view.addSubview(tableView)
    
        view.addSubview(searchHistoryView)
        view.addSubview(popularSearchesView)
        
        view.addSubview(stocksLabel)
        view.addSubview(showMoreButton)
    }

    // MARK: - UIs setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        navigationBarTitleView.search.delegate = self
        
        navigationItem.titleView = navigationBarTitleView
        navigationBarTitleView.search.searchTextField.addTarget(self, action: #selector(searchDidBeginEditingAction), for: .editingDidBegin)
        
        navigationBarTitleView.leftButton.addTarget(self, action: #selector(searchBarLeftButtonPressed), for: .touchUpInside)
        navigationBarTitleView.leftButton.isHidden = true
    }
    
    private func setupButtons() {
        stocksButton.addTarget(self, action: #selector(stocksButtonAction), for: .touchUpInside)
        stocksButton.setAttributedTitle(textStyle(text: "Stocks", size: 30, font: "Montserrat-Bold"), for: .normal)
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
        favouriteButton.setAttributedTitle(textStyle(text: "Favourite", size: 20, font: "Montserrat-Bold", color: UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)), for: .normal)
        
        showMoreButton.setAttributedTitle(textStyle(text: "Show more", size: 14, font: "Montserrat-SemiBold"), for: .normal)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonPressed), for: .touchUpInside)
        
        stocksLabel.attributedText = textStyle(text: "Stocks", size: 20, font: "Montserrat-Bold")
    }
    
    private func setupHistoryViews() {
        popularSearchesView.delegate = self
        searchHistoryView.delegate = self
    }
    
    // MARK: - Buttons Actions
    
    @objc private func showMoreButtonPressed() {
        searchBarLeftButtonPressed(sender: stocksButton)
    }
    
    @objc private func searchBarLeftButtonPressed(sender: UIButton!) {
        if viewState == .stocks {
            navigationBarTitleView.leftButton.isHidden = false
            viewState = .searchHistory
        } else {
            viewState = .stocks
            navigationBarTitleView.leftButton.isHidden = true
            navigationBarTitleView.setSearchImage(image: "Glass")
        }
        tableView.reloadData()
    }
    
    @objc func searchDidBeginEditingAction(sender: UITextField!) {
        if let text = sender.text, text.isEmpty {
            viewState = .searchHistory
        } else {
            viewState = .searchResults
        }
        navigationBarTitleView.leftButton.isHidden = false
    }
    
    private func tickerButtonPressed(ticker: String?) {
        viewState = .searchResults
        
        guard let ticker = ticker else { return }
        navigationBarTitleView.search.text = ticker
        searchBar(navigationBarTitleView.search, textDidChange: ticker)
    }
    
    @objc func favouriteButtonAction(sender: UIButton!) {
        scrollToTop(isFavouriteScreen: true)
        
        sender.setAttributedTitle(textStyle(text: "Favourite", size: 30, font: "Montserrat-Bold"), for: .normal)
        stocksButton.setAttributedTitle(textStyle(text: "Stocks", size: 20, font: "Montserrat-Bold", color: UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)), for: .normal)
    }
    
    @objc func stocksButtonAction(sender: UIButton!) {
        scrollToTop(isFavouriteScreen: false)
        
        sender.setAttributedTitle(textStyle(text: "Stocks", size: 30, font: "Montserrat-Bold"), for: .normal)
        favouriteButton.setAttributedTitle(textStyle(text: "Favourite", size: 20, font: "Montserrat-Bold", color: UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)), for: .normal)
    }
    
    // MARK: - Retrieve Data
    private func retrieveStocksData() {
        viewModel.getStocks()
    }
    
    // MARK: - Binders Setup
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
    }
    
    // MARK: - Keyboard Setup
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
    
    // MARK: - Adding Constraints
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
                
                stocksLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
                stocksLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 23),
                stocksLabel.heightAnchor.constraint(equalToConstant: 39.82),
                
                showMoreButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
                showMoreButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -23),
                showMoreButton.heightAnchor.constraint(equalToConstant: 39.82),
                
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
extension MainVC: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 ? 0 : 4.48)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stocks = (isFiltering ? viewModel.filteredStocks : viewModel.stocks)
        navigationController?.pushViewController(InfoPageVC(stock: stocks[indexPath.section], viewModel: viewModel), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
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
extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewState = .searchResults
        } else {
            guard let isPlaceholderEmpty = searchBar.placeholder?.isEmpty else { return }
            if isPlaceholderEmpty {
                viewState = .searchHistory
            }
        }
        
        viewModel.searchStocks(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "Arrow"), for: .search, state: .normal)
        searchBar.placeholder = ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        CoreDataManager.shared.addSearchedText(text: text.capitalized)
        
        searchHistoryView.addToStack() 
    }
}

// MARK: - SearchHistoryViewProtocol

extension MainVC: SearchHistoryViewProtocol {
    func didTapOnButton(text: String) {
        navigationBarTitleView.search.text = text
        searchBar(navigationBarTitleView.search, textDidChange: text)
    }
}

// MARK: - Additional functions
extension MainVC {
    
    private func textStyle(text: String, size: CGFloat, font: String, color: UIColor = .black) -> NSAttributedString {
        if let font = UIFont(name: font, size: size) {
            return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        }
        return NSAttributedString(string: "")
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
    
}
