//
//  NewNewsTableViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/9/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol TableViewDelegate {
    var tableView: UITableView! { get set }
    func loadData()
    func reloadData()
}

class NewNewsTableViewController: UIViewController {

    // MARK: - Initialization
    
    init(viewModel: NewNewsTableViewModelProtocol = NewNewsTableViewModel(), router: RouterProtocol = NewsTableViewControllerRouter()) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = NewNewsTableViewModel()
        router = NewsTableViewControllerRouter()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties
    
    var viewModel: NewNewsTableViewModelProtocol?
    var router: RouterProtocol?
    
    // MARK: - Outlets & Views
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    private weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router?.viewModel = viewModel
        
        viewModel?.setupActivityIndicator(for: view) { [weak self] activityIndicator in
            self?.activityIndicator = activityIndicator
        }
        
        viewModel?.tableViewDelegate = self
        
        viewModel?.setupTableView()
        
        searchBar.delegate = viewModel as? UISearchBarDelegate
        
        setupData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Force reload tableView for update cell's height after device rotation
        tableView.reloadData()
    }
    
    // MARK: - Data methods
    
    // Setup data
    private func setupData() {
        activityIndicator?.startAnimating()
        viewModel?.setupDataSource()
        loadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func edit(_ sender: UIBarButtonItem) {
        viewModel?.editButtonPressed(sender: sender)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.perform(segue, sender)
    }
    
}

// MARK: - TableViewDelegate

extension NewNewsTableViewController: TableViewDelegate {
    
    func loadData() {
        viewModel?.loadData { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
