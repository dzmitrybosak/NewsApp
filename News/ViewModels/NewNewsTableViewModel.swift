//
//  NewNewsTableViewModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/18/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol NewNewsTableViewModelProtocol {
    var router: Router { get set }
    var tableViewDelegate: TableViewDelegate? { get set }
    var dataSourceService: DataSourceService { get }
    func loadData(completion: @escaping () -> Void)
    func setupDataSource()
}

final class NewNewsTableViewModel: NSObject, NewNewsTableViewModelProtocol {
    
    // MARK: - Initialization
    
    init(dataSourceService: DataSourceService = DataSourceService(), router: Router = NewsTableViewControllerRouter()) {
        self.dataSourceService = dataSourceService
        self.router = router
        self.dataSourceService.delegate.dataSourceDelegate = self.dataSourceService.dataSource
    }
    
    // MARK: - Properties
    
    let dataSourceService: DataSourceService
    
    var router: Router
    
    var tableViewDelegate: TableViewDelegate?
    
    // MARK: - Methods
    
    func loadData(completion: @escaping () -> Void) {
        dataSourceService.dataSource.loadData {
            completion()
        }
    }
    
    func setupDataSource() {
        tableViewDelegate?.tableView.dataSource = dataSourceService.dataSource
        tableViewDelegate?.tableView.delegate = dataSourceService.delegate
        dataSourceService.delegate.viewModel = self
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
        dataSourceService.dataSource.filteredNewsBySource = dataSourceService.dataSource.newsBySource
        
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
            dataSourceService.dataSource.filteredNewsBySource = dataSourceService.dataSource.newsBySource
            tableViewDelegate?.reloadData()
        } else {
            dataSourceService.dataSource.getItems(with: searchText) { [weak self] in
                self?.tableViewDelegate?.reloadData()
            }
        }
    }
    
}

// MARK: - ItemSelectable

extension NewNewsTableViewModel: ItemSelectable {
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let article = dataSourceService.dataSource.filteredNewsBySource[indexPath.section].news?[indexPath.row] else {
            return
        }
        print(article.title ?? "")
        
        let newsService = dataSourceService.dataSource.newsService
        
        router.openArticleViewController(with: article, with: newsService)
    }
    
}
