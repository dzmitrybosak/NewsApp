//
//  NewsService.swift
//  News
//
//  Created by Dzmitry Bosak on 9/5/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import CoreData

final class NewsService {
    
    // MARK: - Singletons
    
    private let newsWebService = WebService.shared
    private let coreDataManager = CoreDataManager.shared
    
    static let shared = NewsService()
    private init() { }
    
    // MARK: - Main methods
    
    // Get News
    func news(callback: @escaping ([Article]) -> Void) {
        newsWebService.getNews { [weak self] (remoteArticles, error) in
            if let _ = error {
                self?.fetchLocalArticles(callback: callback)
                return
            }
            
            self?.storeRemoteArticles(using: remoteArticles, callback: callback)
            self?.fetchLocalArticles(callback: callback)
        }
    }
    
    // Resave Entity
    func resaveEntity(using article: Article, callback: @escaping (Article) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
            for articleEntity in articleEntities {
                
                if article.title == articleEntity.title {
                    articleEntity.setValue(article.likeValue.rawValue, forKey: "likeValue")
                }
            }
            
            try? context.save()
            
            callback(article)
        }
    }
    
    func newsWithPredicate(predicate: String, callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntitiesWithPredicate(predicate: predicate) ?? []
            
            var articles = [Article?]()
            for articleEntity in articleEntities {
                articles.append(articleEntity.map())
            }
            
            callback(articles.compactMap { $0 })
        }
    }
    
    private func fetchArticleEntitiesWithPredicate(predicate: String) -> [ArticleEntity] {
        let context = coreDataManager.context
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: String(describing: ArticleEntity.self))
        
        let filterPredicate = NSPredicate(format: "details contains[c] %@ OR title contains[c] %@", predicate, predicate)
        
        fetchRequest.predicate = filterPredicate
        
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    // MARK: - Private methods
    
    private func fetchLocalArticles(callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
            var articles = [Article?]()
            for articleEntity in articleEntities {
                articles.append(articleEntity.map())
            }
            
            callback(articles.compactMap({ $0 }))
        }
    }
 
    private func storeRemoteArticles(using articles: [Article], callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
             for article in articles {
                
                        let isArticleExisted = articleEntities.contains { entity in
                            if entity.url == article.url?.absoluteString {
                                return true
                            } else {
                                return false
                            }
                        }
                        
                        if isArticleExisted == false {
                            _ = ArticleEntity.create(from: article, in: context)
                        }
                        
                    }
        
            try? context.save()
            callback(articles)
        }
    }
    
    private func fetchArticleEntities(from context: NSManagedObjectContext) -> [ArticleEntity] {
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: String(describing: ArticleEntity.self))
        return (try? context.fetch(fetchRequest)) ?? []
    }
}
