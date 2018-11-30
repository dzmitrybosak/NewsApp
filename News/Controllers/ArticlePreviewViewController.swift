//
//  ArticlePreviewViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/28/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class ArticlePreviewViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articlePreviewView: UIView!
    
    // MARK: - Properties

    weak var configuration: Configuration?

    // MARK: - UIViewController methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupData()
    }
    
    // MARK: - Private methods
    
    private func addArticlePreviewSubview() {
        let topArticleView = ArticlePreviewView.instanceFromNib()
        view.addSubview(topArticleView)
        
        topArticleView.translatesAutoresizingMaskIntoConstraints = false
        topArticleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topArticleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topArticleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topArticleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func loadArticle(callback: @escaping (Article) -> Void) {
        let newsDataSource = NewsDataSource()

        newsDataSource.loadTopArticle { article in
            callback(article)
        }
    }
    
    private func setupData() {
        loadArticle { [weak self] topArticle in
           
            guard let configure = self?.view as? Configuration else {
                return
            }
            
            configure.configure(with: topArticle)
        }
    }
    
}
