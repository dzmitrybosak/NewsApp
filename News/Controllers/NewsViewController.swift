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
    static let cancelButton = "cancelButton"
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
//        collectionView.delegate = self
        
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showArticle.rawValue:
            guard let newsCell = sender as? NewsCell, let articleViewController = segue.destination as? ArticleViewController else {
                return
            }
            
            articleViewController.article = newsCell.article
            articleViewController.delegate = self
            
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

// MARK: - ArticleViewControllerDelegate

extension NewsViewController: ArticleViewControllerDelegate {
    func didLiked(_ article: Article) {
        guard let index = news.index(where: { $0.url == article.url } ) else {
            return
        }
        
        news[index] = article
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth: CGFloat = 158.0
        
        let bigItemHeigh: CGFloat = 158.0
        let smallItemHeigh: CGFloat = 77.0

        var itemSize = CGSize(width: itemWidth, height: smallItemHeigh)
        
        let count = collectionView.numberOfItems(inSection: 0)
        
        var lastBigItemIndex = 0
        var currentIndex = 0
        
        var bigIndexesArray: [Int] = []
        
        // Calculation
        while currentIndex < count {
            
            switch currentIndex {
            case 0:
                lastBigItemIndex = currentIndex
                bigIndexesArray.append(lastBigItemIndex)
                
            case lastBigItemIndex + 5:
                lastBigItemIndex = currentIndex
                bigIndexesArray.append(lastBigItemIndex)
                lastBigItemIndex = currentIndex + 1
                bigIndexesArray.append(lastBigItemIndex)
                
            default:
                break
            }
            
            currentIndex += 1
        }
        
        for index in bigIndexesArray {
            if indexPath.item == index {
                itemSize = CGSize(width: itemWidth, height: bigItemHeigh)
            }
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interitemSpacing: CGFloat = 2.0
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 5.0
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let collectionViewWidth = collectionView.bounds.size.width
        let itemWidth: CGFloat = 160.0
        let columnsCount: CGFloat = collectionViewWidth / itemWidth
        let inset = (collectionViewWidth - columnsCount.rounded(.down) * itemWidth) / columnsCount.rounded(.down)
        let edgeInsets = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        
        return edgeInsets
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
        
        if let cancelButton = searchBar.value(forKey: Constants.cancelButton) as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredNews = news
        } else {
            DispatchQueue.main.async {
                self.newsService.newsWithPredicate(predicate: searchText, callback: { [weak self] news in
                    
                    // Sort by date
                    let sortedNews = news.sorted(by: { (firstArticle: Article, secondArticle: Article) -> Bool in
                        return firstArticle.publishedAt?.compare(secondArticle.publishedAt!) == .orderedDescending
                    })
                    
                    self?.filteredNews = sortedNews
                })
            }
        }
    }
    
}
