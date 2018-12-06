//
//  ArticlePreviewViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/28/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol Action: class {
    func openArticle()
    func close()
}

final class ArticlePreviewViewController: UIViewController {

    // MARK: - Initialization
    
    init() {
        self.newsDataSource = NewsDataSource.shared
        self.delegate = self.newsDataSource
        super.init(nibName: String(describing: ArticlePreviewViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.newsDataSource = NewsDataSource.shared
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties
    
    private let newsDataSource: NewsDataSource

    weak var configuration: Configuration?
    weak var delegate: ArticleViewControllerDelegate?
    
    private var article: Article?
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addArticlePreviewSubview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Private methods

    private func addArticlePreviewSubview() {
        
        guard let articlePreviewView = ArticlePreviewView().loadNib() as? ArticlePreviewView else {
            return
        }
        
        articlePreviewView.action = self

        setupData(for: articlePreviewView)
        
        view.addSubview(articlePreviewView)
        
        articlePreviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articlePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articlePreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            articlePreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            articlePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadArticle(callback: @escaping (Article) -> Void) {        
        newsDataSource.loadTopArticle { article in
            self.article = article
            callback(article)
        }
    }
    
    private func setupData(for view: UIView) {
        loadArticle { topArticle in
            
            guard let configure = view as? Configuration else {
                return
            }

            configure.configure(with: topArticle)
        }
    }
    
}

// MARK: - Action Protocol

extension ArticlePreviewViewController: Action {
    
    func openArticle() {
        openArticleViewController()
    }
    
    func close() {
        
        guard let article = article else {
            return
        }
        
        delegate?.didLiked(article)
        
        dismiss(animated: true)
    }
    
    private func openArticleViewController() {
        
        guard let topArticle = article,
              let articleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleVC") as? ArticleViewController
            else {
                return
        }
        
        articleViewController.article = topArticle
        
        navigationController?.pushViewController(articleViewController, animated: true)
        
        articleViewController.navigationController?.navigationBar.isHidden = false
        articleViewController.navigationItem.hidesBackButton = true
        
        let closeBarButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(popToRoot))
        articleViewController.navigationItem.setRightBarButton(closeBarButton, animated: true)
    }

    @objc private func popToRoot(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
}
