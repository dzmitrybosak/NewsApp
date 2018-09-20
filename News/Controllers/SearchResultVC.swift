//
//  SearchResultVC.swift
//  News
//
//  Created by Dzmitry Bosak on 9/12/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellID = "tableCell"
    static let mainStoryboardID = "Main"
    static let searchResultsStoryboardID = "SearchResultsVC"
    static let articleVC = "ArticleVC"
}

class SearchResultsVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private let newsService = NewsService.shared
    
    private var allNews: [Article] = []
    private var filteredNews: [Article] = []
    
    // For initialization
    class func initialize(with news: [Article]) -> SearchResultsVC {
        let storyboard = UIStoryboard(name: Constants.mainStoryboardID, bundle: nil)
        guard let searchVC = storyboard.instantiateViewController(withIdentifier: Constants.searchResultsStoryboardID) as? SearchResultsVC else { fatalError("Unable to instatiate a SearchResultsVC from the storyboard.") }
        searchVC.allNews = news
        return searchVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Private instance methods
        
    private func filterContentForSearchText(_ searchText: String) {
        filteredNews = allNews.filter({ (article: Article) -> Bool in
            if article.description != nil, article.title != nil {
                return (article.description?.lowercased().contains(searchText.lowercased()))! || (article.title?.lowercased().contains(searchText.lowercased()))!
            } else {
                return false
            }
        })
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source

extension SearchResultsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? TableNewsCell else { return UITableViewCell() }
        
        let article = filteredNews[indexPath.row]
        cell.article = article
        
        return cell
    }
}

// MARK: - Table View Delegate

extension SearchResultsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        
        guard let newsCell = tableView.cellForRow(at: indexPath) as? TableNewsCell, let destinationVC = storyboard?.instantiateViewController(withIdentifier: Constants.articleVC) as? ArticleVC else {
            return
        }
        
        destinationVC.article = newsCell.article
        
        //navigationController.pushViewController(destinationVC, animated: true)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - Search Results Updating

extension SearchResultsVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
