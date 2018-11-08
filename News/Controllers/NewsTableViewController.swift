//
//  NewsTableViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 9/11/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

private struct Constants {
    static let cellID = "TableNewsCell"
    static let cancelButton = "cancelButton"
}

private enum Segues: String {
    case showArticle = "showArticle"
}

class NewsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableSearchBar: UISearchBar!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    private weak var tableFooterView: UIView?
    
    private let newsService = NewsService.shared
    private let sortService = SortService.shared
    
    private var news: [Article] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator?.stopAnimating()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    private var filteredNews: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityIndicator()
        
        tableSearchBar.delegate = self
        
        setupData()
        
        setupRefreshControl()
        
        hideSeparatorForEmptyCells()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Force reload tableView for update cell's height after device rotation
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    // Load and sort data
    private func loadData() {
        newsService.news { [weak self] news in
            self?.news = news
            self?.filteredNews = news
        }
    }
    
    // Setup data
    private func setupData() {
        activityIndicator?.startAnimating()
        
        loadData()
    }
    
    private func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.activityIndicator = activityIndicator
    }
    
    // Setup Refresh Control
    private func setupRefreshControl() {
        tableView.refreshControl?.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = .white
    }

    @objc private func didRefresh(_ sender: Any) {
        loadData()
    }
    
    // Hide separator for empty cells
    private func hideSeparatorForEmptyCells() {
        let tableFooterView = UIView(frame: .zero)
        self.tableFooterView = tableFooterView
        tableView.tableFooterView = self.tableFooterView
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? TableNewsCell else {
            return UITableViewCell()
        }
        
        // Set selection background color
        cell.selectedBackgroundView = cell.setSelectionColor()
        
        let article = filteredNews[indexPath.row]
        cell.article = article
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func sort(_ sender: UIBarButtonItem) {
        filteredNews = sortService.quicksort(filteredNews)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showArticle.rawValue:
            guard let newsCell = sender as? TableNewsCell, let articleViewController = segue.destination as? ArticleViewController else {
                return
            }
            
            articleViewController.article = newsCell.article
            articleViewController.delegate = self
            
        default:
            break
        }
    }
    
}

// MARK: - ArticleViewControllerDelegate

extension NewsTableViewController: ArticleViewControllerDelegate {
    func didLiked(_ article: Article) {
        guard let index = news.index(where: { $0.url == article.url } ) else {
            return
        }
        
        news[index] = article
    }
}

// MARK: - UISearchBarDelegate

extension NewsTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredNews = news
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if !searchText.isEmpty {
            tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
        
        if let cancelButton = tableSearchBar.value(forKey: Constants.cancelButton) as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredNews = news
        } else {
            DispatchQueue.main.async {
                self.newsService.sortedNewsWithPredicate(predicate: searchText) { [weak self] news in
                    self?.filteredNews = news
                }
            }
        }
    }
    
}
