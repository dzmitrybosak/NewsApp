//
//  NewNewsTableViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/9/18.
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

class NewNewsTableViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    
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
    
    private var filteredNews: [Article] = []
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityIndicator()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
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
            self?.tableView.reloadData()
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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = .white
        
        let attributedString = NSAttributedString(string: "Pull down to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        tableView.refreshControl?.attributedTitle = attributedString
    }
    
    @objc private func didRefresh(_ sender: Any) {
        loadData()
    }
    
    // Hide separator for empty cells
    private func hideSeparatorForEmptyCells() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Methods for buttons
    
    private func sortButtonPressed() {
        filteredNews = sortService.quicksort(filteredNews)
    }
    
    private func editButtonPressed() {
        if tableView.isEditing == true {
            tableView.isEditing = false
            editButton.title = "Edit"
            loadData()
        } else {
            tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sort(_ sender: UIBarButtonItem) {
        sortButtonPressed()
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        editButtonPressed()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showArticle.rawValue:
            guard let newsCell = sender as? TableNewsCell,
                let index = tableView.indexPath(for: newsCell),
                let articleViewController = segue.destination as? ArticleViewController
                else {
                    return
            }
            
            articleViewController.article = filteredNews[index.row]
            articleViewController.delegate = self
            
        default:
            break
        }
    }
    
}

// MARK: - UITableViewDataSource

extension NewNewsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? TableNewsCell else {
            return UITableViewCell()
        }
        
        let article = filteredNews[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let article = filteredNews[indexPath.row]
        
        guard let url = article.url?.absoluteString else {
            return
        }
        
        if editingStyle == .delete {
            news.remove(at: indexPath.row)
            filteredNews.remove(at: indexPath.row)
            newsService.removeEntity(with: url)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NewNewsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Enable cancelButton in searchBar when scrollView will begin dragging
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        enableCancelButton(in: searchBar)
    }
    
}

// MARK: - ArticleViewControllerDelegate

extension NewNewsTableViewController: ArticleViewControllerDelegate {
    func didLiked(_ article: Article) {
        guard let index = news.index(where: { $0.url == article.url } ) else {
            return
        }
        
        news[index] = article
    }
}

// MARK: - UISearchBarDelegate

extension NewNewsTableViewController: UISearchBarDelegate {
    
    private func enableCancelButton(in searchBar: UISearchBar) {
        guard let cancelButton = searchBar.value(forKey: Constants.cancelButton) as? UIButton else {
            return
        }
        
        cancelButton.isEnabled = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredNews = news
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if !searchText.isEmpty {
            tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
        
        enableCancelButton(in: searchBar)
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
        tableView.reloadData()
    }
    
}
