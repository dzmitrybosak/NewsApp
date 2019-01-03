//
//  NewsViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 9/11/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
//import AlamofireImage

//private struct Constants {
//    static let cellID = "newsCell"
//    static let cancelButton = "cancelButton"
//}
//
//private enum Segues: String {
//    case showArticle = "showArticle"
//}

class NewsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
//    private let refreshControl = UIRefreshControl()
//
//    private let newsService = NewsService.shared
//    private let sortService = SortService.shared
//
//    private var news: [Article] = [] {
//        didSet {
//            DispatchQueue.main.async { [weak self] in
//                self?.activityIndicator.stopAnimating()
//            }
//        }
//    }
//
//    private var filteredNews: [Article] = [] {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.dataSource = self
//
//        setupLayout()
//
//        setupData()
//
//        setupRefreshControl()
    }
//
//    // MARK: - Private methods
//
//    // Set Collection View Layout
//    private func setupLayout() {
//        let layout = MosaicLayout()
//        collectionView.collectionViewLayout = layout
//    }
//
//    // Load and sort data
//    private func loadData() {
//        self.newsService.news { [weak self] news in
//
//            // Sort by date
//            let sortedNews = news.sorted { $0.publishedAt?.compare($1.publishedAt ?? Date()) == .orderedDescending }
//
//            self?.news = sortedNews
//            self?.filteredNews = sortedNews
//        }
//    }
//
//    // Setup data
//    private func setupData() {
//        activityIndicator.startAnimating()
//
//        loadData()
//
//        DispatchQueue.main.async { [weak self] in
//            if self?.refreshControl.isRefreshing == true {
//                self?.activityIndicator.isHidden = true
//            }
//            self?.refreshControl.endRefreshing()
//        }
//    }
//
//    // Setup Refresh Control
//    private func setupRefreshControl() {
//        collectionView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
//        refreshControl.tintColor = .white
//
//        let attributedString = NSAttributedString(string: "Pull down to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//
//        refreshControl.attributedTitle = attributedString
//    }
//
//    @objc private func didRefresh(_ sender: Any) {
//        setupData()
//    }
//
//    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let segueID = segue.identifier else {
//            return
//        }
//
//        switch segueID {
//        case Segues.showArticle.rawValue:
//            guard let newsCell = sender as? NewsCell, let articleViewController = segue.destination as? ArticleViewController else {
//                return
//            }
//
////            articleViewController.article = newsCell.article
////            articleViewController.delegate = self
//
//        default:
//            break
//        }
//    }
//
//    // MARK: - Actions
//
//    @IBAction func sort(_ sender: UIBarButtonItem) {
//        filteredNews = sortService.quicksort(filteredNews)
//        collectionView.reloadData()
//    }
//
}
//
//// MARK: - ArticleViewControllerDelegate
//
//extension NewsViewController: ArticleViewModelDelegate {
//    func didLiked(_ article: ArticleModel) {
//        guard let index = news.index(where: { $0.url == article.url } ) else {
//            return
//        }
//
//        news[index] = article
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension NewsViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       return filteredNews.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? NewsCell else {
//            return UICollectionViewCell()
//        }
//
//        let article = filteredNews[indexPath.row]
//        cell.article = article
//
//        return cell
//    }
//}
//
//// MARK: - UISearchBarDelegate
//
//extension NewsViewController: UISearchBarDelegate {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        filteredNews = news
//        searchBar.setShowsCancelButton(false, animated: true)
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        guard let searchText = searchBar.text else {
//            return
//        }
//
//        if !searchText.isEmpty {
//            collectionView.reloadData()
//        }
//
//        searchBar.resignFirstResponder()
//
//        if let cancelButton = searchBar.value(forKey: Constants.cancelButton) as? UIButton {
//            cancelButton.isEnabled = true
//        }
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchText.isEmpty {
//            filteredNews = news
//        } else {
//            DispatchQueue.main.async {
//                self.newsService.newsWithPredicate(predicate: searchText) { [weak self] news in
//
//                    // Sort by date
//                    let sortedNews = news.sorted { ($0.publishedAt ?? Date()) < ($1.publishedAt ?? Date()) }
//
//                    self?.filteredNews = sortedNews
//                }
//            }
//        }
//    }
//
//}
