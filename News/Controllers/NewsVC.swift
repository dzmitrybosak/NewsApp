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
}

private enum Segues: String {
    case showArticle = "showArticle"
    case showWebView = "showWebView"
}

class NewsVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    private let newsService = NewsService.shared
    private let sortService = SortService.shared
    
    private var isLoadingViewController = false
    
    private var news: [Article] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.configureSearchController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        setupLayout()
        
        isLoadingViewController = true
        setupData()
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: - Closure instead of this code
        if isLoadingViewController {
            isLoadingViewController = false
        } else {
            
        }
    }
    
    // MARK: - Private instance methods
    
    // Set Collection View Layout
    private func setupLayout() {
        let layout = MosaicLayout()
        collectionView.collectionViewLayout = layout
    }
    
    // Setup data
    private func setupData() {
        activityIndicator.startAnimating()
        
        newsService.news { [weak self] news in
            
            // Sort by date
            let sortedNews = news.sorted(by: { (firstArticle: Article, secondArticle: Article) -> Bool in
                return firstArticle.publishedAt?.compare(secondArticle.publishedAt!) == .orderedDescending
            })

            self?.news = sortedNews
        }
        
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing == true {
                self.activityIndicator.isHidden = true
            }
            self.refreshControl.endRefreshing()
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
        news = sortService.quicksort(news)
    }
    
}

// MARK: - UICollectionViewDataSource

extension NewsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        
        let article = news[indexPath.row]
        cell.article = article
        
        return cell
    }
}
