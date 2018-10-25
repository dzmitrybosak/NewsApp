//
//  NewsVC.swift
//  News
//
//  Created by Dzmitry Bosak on 9/11/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

private enum Constants {
    static let imageHolder = "placeholder"
    static let cellID = "newsCell"
    static let searchField = "searchField"
    static let collectionViewHeader = "collectionViewHeader"
}

private enum Segues: String {
    case showArticle = "showArticle"
    case showWebView = "showWebView"
}

class NewsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let refreshControl = UIRefreshControl()
    
    private let newsService = NewsService.shared
    private let sortService = SortService.shared
    
    private var news: [Article] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                //self?.configureSearchController()
            }
        }
    }

    private var filteredNews: [Article] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        setupLayout()
        
        setupData()
        
        setupRefreshControl()
    }
    
    // MARK: - Private instance methods
    
    // Set Collection View Layout
    private func setupLayout() {
        let layout = MosaicLayout()
        collectionView.collectionViewLayout = layout
    }
    
    // Load and sort data
    private func loadData() {
        DispatchQueue.global(qos: .utility).async {
            self.newsService.news { [weak self] news in

                // Sort by date
                let sortedNews = news.sorted(by: { (firstArticle: Article, secondArticle: Article) -> Bool in
                    return firstArticle.publishedAt?.compare(secondArticle.publishedAt!) == .orderedDescending
                })

                self?.news = sortedNews
                self?.filteredNews = sortedNews
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
        }
    }
    
    // Setup data
    private func setupData() {
        activityIndicator.startAnimating()
        
        loadData()
        
        DispatchQueue.main.async { [weak self] in
            if self?.refreshControl.isRefreshing == true {
                self?.activityIndicator.isHidden = true
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    // Setup Refresh Control
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .white

        let attributedString = NSAttributedString(string: "Pull down to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

        refreshControl.attributedTitle = attributedString
    }
    
    @objc private func didRefresh(_ sender: Any) {
        setupData()
    }
    
    /*
    // Setup search
    private func configureSearchController() {
        
        let searchResultsVC = SearchResultsVC.initialize(with: news)

        let navigationController = UINavigationController(rootViewController: searchResultsVC)
        let searchController = UISearchController(searchResultsController: navigationController)
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = searchResultsVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .lightGray
        definesPresentationContext = true
        
        // Search Bar Style
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: Constants.searchField) as? UITextField {
            if let backgroundView = textFieldInsideSearchBar.subviews.first {
                backgroundView.backgroundColor = .white
                backgroundView.layer.cornerRadius = 10
                backgroundView.clipsToBounds = true
            }
        }
    }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showArticle.rawValue:
            guard let newsCell = sender as? NewsCell, let articleVC = segue.destination as? ArticleVC else {
                return
            }
            
            articleVC.article = newsCell.article
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sort(_ sender: UIBarButtonItem) {
        filteredNews = sortService.quicksort(filteredNews)
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource

extension NewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filteredNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        
        let article = filteredNews[indexPath.row]
        cell.article = article
        
        return cell
    }
}

// MARK: - Search

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredNews = news
//        collectionView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if !searchText.isEmpty {
            collectionView.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredNews = news
//            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.newsService.newsWithPredicate(predicate: searchText, callback: { [weak self] news in
                    self?.filteredNews = news
                })
            }
        }
    }
    
}
