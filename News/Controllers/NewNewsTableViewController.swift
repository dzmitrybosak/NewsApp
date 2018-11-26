//
//  NewNewsTableViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/9/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

struct Section {
    static let header = "SectionHeader"
    static let footer = "SectionFooter"
}

private struct Constants {
    static let cancelButton = "cancelButton"
}

private enum Segues: String {
    case showArticle = "showArticle"
}

class NewNewsTableViewController: UIViewController {

    // MARK: - Outlets & Views
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - Properties
    
    private let newsDataSource = NewsDataSource()
    private let newsTableViewDelegate = NewsTableViewDelegate()
    
    private var newsDidLoad: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator?.stopAnimating()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        
        registerNibs()
        setupRefreshControl()
        hideSeparatorForEmptyCells()
        
        setupSearchBarDelegate()
        
        setupData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Force reload tableView for update cell's height after device rotation
        tableView.reloadData()
    }
    
    // MARK: - Data methods
    
    // Setup DataSource & Delegate for TableView
    private func setupDataSource(for tableView: UITableView) {
        tableView.dataSource = newsDataSource
        tableView.delegate = newsTableViewDelegate
        newsTableViewDelegate.headersDataSource = newsDataSource
    }
    
    // Setup data
    private func setupData() {
        activityIndicator?.startAnimating()
        setupDataSource(for: tableView)
        loadData()
    }
    
    // Load data
    private func loadData() {
        newsDataSource.loadData { [weak self] newsDidLoad in
            //self?.newsDidLoad = true
            self?.newsDidLoad = newsDidLoad
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Buttons methods
    
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
            articleViewController.article = newsDataSource.filteredNewsBySource[index.section].news?[index.row]
            articleViewController.delegate = newsDataSource
            
        default:
            break
        }
    }
    
}

// MARK: - View methods

extension NewNewsTableViewController {
    
    // Enable cancelButton in searchBar when scrollView will begin dragging
    private func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        enableCancelButton(in: searchBar)
    }

    // Setup Activity Indicator
    private func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.activityIndicator = activityIndicator
    }

}

// MARK: - TableView methods

extension NewNewsTableViewController {

    // Register nib files
    private func registerNibs() {
        let sectionHeaderNib = UINib(nibName: Section.header, bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: Section.header)
        
        let sectionFooterNib = UINib(nibName: Section.footer, bundle: nil)
        tableView.register(sectionFooterNib, forHeaderFooterViewReuseIdentifier: Section.footer)
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
    
}

// MARK: - UISearchBarDelegate

extension NewNewsTableViewController: UISearchBarDelegate {
    
    // Setup Search Bar Delegate
    private func setupSearchBarDelegate() {
        searchBar.delegate = self
    }
    
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
        newsDataSource.filteredNewsBySource = newsDataSource.newsBySource
        
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
            newsDataSource.filteredNewsBySource = newsDataSource.newsBySource
            tableView.reloadData()
        } else {
            newsDataSource.getItems(with: searchText) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
}
