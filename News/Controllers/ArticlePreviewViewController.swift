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

    weak var configuration: Configuration?

    // MARK: - UIViewController methods
    
    init() {
        super.init(nibName: String(describing: ArticlePreviewViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addArticlePreviewSubview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - Private methods
    
    private func addArticlePreviewSubview() {
        let articlePreviewView = ArticlePreviewView()
        view.addSubview(articlePreviewView)
        articlePreviewView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articlePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articlePreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            articlePreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            articlePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    
//    private func addArticlePreviewSubview() {
//        let topArticleView = ArticlePreviewView.instanceFromNib()
//        view.addSubview(topArticleView)
//
//        topArticleView.translatesAutoresizingMaskIntoConstraints = false
//        topArticleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        topArticleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        topArticleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        topArticleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    }
    
    private func loadArticle(callback: @escaping (Article) -> Void) {
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
