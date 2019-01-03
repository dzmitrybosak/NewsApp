//
//  ArticleViewModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/19/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

protocol ArticleViewModelDelegate: class {
    func didLiked(_ article: ArticleModel)
}

protocol ArticleViewModelProtocol {
    var router: Router { get set }
    var article: ArticleModel? { get set }
    func likeSelected(completion: @escaping () -> Void)
    func dislikeSelected(completion: @escaping () -> Void)
}

final class ArticleViewModel: ArticleViewModelProtocol  {
    
    // MARK: - Initialization
  
    init(newsService: NewsService, router: Router) {
        self.newsService = newsService
        self.router = router
    }
    
    // MARK: - Properties
    
    private let newsService: NewsService
    
    var router: Router
    
    weak var delegate: ArticleViewModelDelegate?
    
    var article: ArticleModel?
    
    // MARK: - Methods
    
    func likeSelected(completion: @escaping () -> Void) {
        guard var article = article else {
            return
        }

        article.likeValue = .isLiked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        completion(/*check like value*/)
    }
    
    
    func dislikeSelected(completion: @escaping () -> Void) {
        guard var article = article else {
            return
        }
        
        article.likeValue = .isDisliked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        completion(/*check like value*/)
    }
}
