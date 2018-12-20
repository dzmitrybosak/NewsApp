//
//  NewNewsTableViewModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/18/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol NewNewsTableViewModelProtocol {
    var tableViewDelegate: TableViewDelegate? { get set }
    
    var newsDataSource: NewsDataSource { get }
    var newsTableViewDelegate: NewsTableViewDelegate { get }
    
    func loadData(completion: @escaping () -> Void)
    
    func setupDataSource()
    func editButtonPressed(sender: UIBarButtonItem)
    func setupTableView()
    
    func setupActivityIndicator(for view: UIView, completion: @escaping (UIActivityIndicatorView) -> Void)
}

final class NewNewsTableViewModel: NSObject, NewNewsTableViewModelProtocol {
    
    // MARK: - Initialization
    
    init(newsDataSource: NewsDataSource = NewsDataSource.shared, newsTableViewDelegate: NewsTableViewDelegate = NewsTableViewDelegate()) {
        self.newsDataSource = newsDataSource
        self.newsTableViewDelegate = newsTableViewDelegate
    }
    
    // MARK: - Properties
    
    var newsDataSource: NewsDataSource
    var newsTableViewDelegate: NewsTableViewDelegate
    
    var tableViewDelegate: TableViewDelegate?
    
    // MARK: - Methods
    
    func loadData(completion: @escaping () -> Void) {
        newsDataSource.loadData {
            completion()
        }
    }
    
    func setupDataSource() {
        tableViewDelegate?.tableView.dataSource = newsDataSource
        tableViewDelegate?.tableView.delegate = newsTableViewDelegate
        newsTableViewDelegate.headersDataSource = newsDataSource
    }
    
    func editButtonPressed(sender: UIBarButtonItem) {
        if tableViewDelegate?.tableView.isEditing == true {
            tableViewDelegate?.tableView.isEditing = false
            sender.title = "Edit"
        } else {
            tableViewDelegate?.tableView.isEditing = true
            sender.title = "Done"
        }
    }
    
    func setupActivityIndicator(for view: UIView, completion: @escaping (UIActivityIndicatorView) -> Void) {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        completion(activityIndicator)
    }
    
}

// MARK: - TableView methods

extension NewNewsTableViewModel {
    
    func setupTableView() {
        
        guard let tableView = tableViewDelegate?.tableView else {
            return
        }
        
        registerNibs(for: tableView)
        setupRefreshControl(for: tableView)
        hideSeparatorForEmptyCells(for: tableView)
    }
    
    func registerNibs(for tableView: UITableView) {
        let sectionHeaderNib = UINib(nibName: Section.header, bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: Section.header)
    }
    
    func setupRefreshControl(for tableView: UITableView) {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = .white
        
        let attributedString = NSAttributedString(string: "Pull down to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        tableView.refreshControl?.attributedTitle = attributedString
    }
    
    @objc private func didRefresh(_ sender: Any) {
        tableViewDelegate?.loadData()
    }
    
    func hideSeparatorForEmptyCells(for tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
}

// MARK: - UISearchBarDelegate

extension NewNewsTableViewModel: UISearchBarDelegate {
    
    private struct Constants {
        static let cancelButton = "cancelButton"
    }
    
    func enableCancelButton(in searchBar: UISearchBar) {
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
        tableViewDelegate?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if !searchText.isEmpty {
            tableViewDelegate?.reloadData()
        }
        
        searchBar.resignFirstResponder()
        
        enableCancelButton(in: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            newsDataSource.filteredNewsBySource = newsDataSource.newsBySource
            tableViewDelegate?.reloadData()
        } else {
            newsDataSource.getItems(with: searchText) { [weak self] in
                self?.tableViewDelegate?.reloadData()
            }
        }
    }
    
}
