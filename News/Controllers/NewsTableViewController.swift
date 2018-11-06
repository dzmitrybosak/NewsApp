//
//  NewsVC.swift
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
    
    private var activityIndicator: UIActivityIndicatorView?
    
    private let newsService = NewsService.shared
    private let sortService = SortService.shared
    
    private var news: [Article] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator?.stopAnimating()
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
    }
    
    // MARK: - Private instance methods
    
    // Load and sort data
    private func loadData() {
        self.newsService.news { [weak self] news in

            // Sort by date
            let sortedNews = news.sorted { $0.publishedAt?.compare($1.publishedAt ?? Date()) == .orderedDescending }

            self?.news = sortedNews
            self?.filteredNews = sortedNews
        }
    }
    
    // Setup data
    private func setupData() {
        activityIndicator?.startAnimating()
        
        loadData()
        
        DispatchQueue.main.async { [weak self] in
            if self?.tableView.refreshControl?.isRefreshing == true {
                self?.activityIndicator?.isHidden = true
            }
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func addActivityIndicator() {

        activityIndicator = UIActivityIndicatorView()
        
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
    }
    
    // Setup Refresh Control
    private func setupRefreshControl() {
        tableView.refreshControl?.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = .white
    }

    @objc private func didRefresh(_ sender: Any) {
        setupData()
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? TableNewsCell else {
            return UITableViewCell()
        }
        
        let article = filteredNews[indexPath.row]
        cell.article = article
        
        return cell
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

// MARK: - Search

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
        
        if let cancelButton = searchBar.value(forKey: Constants.cancelButton) as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredNews = news
        } else {
            DispatchQueue.main.async {
                self.newsService.newsWithPredicate(predicate: searchText) { [weak self] news in
                    
                    // Sort by date
                    let sortedNews = news.sorted { $0.publishedAt?.compare($1.publishedAt ?? Date()) == .orderedDescending }

                    self?.filteredNews = sortedNews
                }
            }
        }
    }
    
}
