//
//  ArticleViewModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/19/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

protocol ArticleViewModelDelegate: class {
    func didLiked(_ article: Article)
}

protocol ArticleViewModelProtocol {
    var article: Article? { get set }
    var sourceName: String? { get }
    var author: String? { get }
    var title: String? { get }
    var description: String? { get }
    var imageURL: URL? { get }
    var date: String? { get }
    var url: URL? { get }
    func setupData()
    func likeSelected(completion: @escaping () -> Void)
    func dislikeSelected(completion: @escaping () -> Void)
}

final class ArticleViewModel: ArticleViewModelProtocol  {
    
    // MARK: - Initialization
    
    init(dateFormatService: DateFormatService = DateFormatService.shared, newsService: NewsService = NewsService.shared) {
        self.dateFormatService = dateFormatService
        self.newsService = newsService
    }
    
    // MARK: - Properties
    
    private let dateFormatService: DateFormatService
    private let newsService: NewsService
    
    weak var delegate: ArticleViewModelDelegate?
    
    var article: Article?
    
    var sourceName: String?
    var author: String?
    var title: String?
    var description: String?
    var date: String?
    var imageURL: URL?
    var url: URL?
    
    // MARK: - Methods
    
    func setupData() {
        guard let article = article else {
            return
        }
        
        sourceName = article.sourceName
        author = article.author
        title = article.title
        description = article.description
        imageURL = article.urlToImage
        url = article.url
        
        if let publishedAt = article.publishedAt {
            date = dateFormatService.fromDate(publishedAt)
        }
    }
    
    func likeSelected(completion: @escaping () -> Void) {
        guard let article = article else {
            return
        }
        article.likeValue = .isLiked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        completion() // check like value
    }
    
    
    func dislikeSelected(completion: @escaping () -> Void) {
        guard let article = article else {
            return
        }
        
        article.likeValue = .isDisliked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        completion() // check like value
    }
}
