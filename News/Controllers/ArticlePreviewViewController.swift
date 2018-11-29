//
//  ArticlePreviewViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/28/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class ArticlePreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private let newsDataSource = NewsDataSource()
    
    weak var configure: Configure?
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupNib()
    }
    
    // MARK: - Private methods
    
    private func setupConfigure() {
        let articlePreviewView = ArticlePreviewView()
        configure = articlePreviewView
    }
    
    private func setupNib() {
        let topArticleView = ArticlePreviewView.instanceFromNib()
        view.addSubview(topArticleView)
        
        topArticleView.translatesAutoresizingMaskIntoConstraints = false
        topArticleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topArticleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topArticleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topArticleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func loadArticle(callback: @escaping (Article) -> Void) {
        newsDataSource.loadTopArticle { article in
            callback(article)
        }
    }
    
    private func setupData() {
        setupConfigure()
        
        loadArticle { [weak self] topArticle in
            self?.configure?.configure(with: topArticle)
        }
    }
    
}
