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
    
    init(viewModel: NewNewsTableViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = NewNewsTableViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties
    
    private var viewModel: NewNewsTableViewModelProtocol
    
    // MARK: - Outlets & Views
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    private weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        
        viewModel.tableViewDelegate = self
        viewModel.router.viewController = self
        
        setupTableView()
        
        searchBar.delegate = viewModel as? UISearchBarDelegate
        
        setupData()
    }
    
    // MARK: - UIView methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Force reload tableView for update cell's height after device rotation
        tableView.reloadData()
    }
    
    private func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.activityIndicator = activityIndicator
    }
    
    // MARK: - Data methods
    
    // Setup data
    private func setupData() {
        activityIndicator?.startAnimating()
        viewModel.setupDataSource()
        loadData()
    }
    
    // MARK: - Actions
    
    private func editButtonPressed() {
        if tableView.isEditing == true {
            tableView.isEditing = false
            editButton.title = "Edit"
        } else {
            tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    @IBAction private func edit(_ sender: UIBarButtonItem) {
        editButtonPressed()
    }
}

// MARK: - TableView methods

extension NewNewsTableViewController {
    
    private func setupTableView() {
        registerNibs()
        setupRefreshControl()
        hideSeparatorForEmptyCells()
    }
    
    private func registerNibs() {
        let sectionHeaderNib = UINib(nibName: Section.header, bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: Section.header)
    }
    
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
    
    private func hideSeparatorForEmptyCells() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
}

// MARK: - TableViewDelegate

extension NewNewsTableViewController: TableViewDelegate {
    
    func loadData() {
        viewModel.loadData { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
