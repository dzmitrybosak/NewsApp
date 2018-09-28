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
//        collectionView.delegate = self
        
        setupLayout()
        
        setupData()
        
        setupRefreshControl()
    }
    
    // MARK: - Private instance methods
    
    // Set Collection View Layout
    private func setupLayout() {
        let layout = AppleMosaicLayout()
        collectionView.collectionViewLayout = layout
        //layout.delegate = self
    }
    
    // Setup data
    private func setupData() {
        activityIndicator.startAnimating()
        
        newsService.news { [weak self] news in
            self?.news = news
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
    
    @objc
    private func didRefresh(_ sender: Any) {
        setupData()
    }
    
    // Setup search
    private func configureSearchController() {
        
        let searchResultsVC = SearchResultsVC.initialize(with: news)
//        let searchController = UISearchController(searchResultsController: searchResultsVC)
        
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

// MARK: -  UICollectionViewDelegateFlowLayout - 1 large, 2 small

/*extension NewsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        var numberOfCellsPerLine = 0
        
        if indexPath.item % 3 == 0 {
            numberOfCellsPerLine = 1
        } else {
            numberOfCellsPerLine = 2
        }
        
        // Generic cell width calculation
        let cellWidth = (collectionView.bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right) - flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsPerLine - 1)) / CGFloat(numberOfCellsPerLine)
        return CGSize(width: cellWidth, height: cellWidth / 2)
    }
    
}*/


