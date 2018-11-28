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
        DispatchQueue.global(qos: .utility).async {
            self.newsWebService.getNews { [weak self] (remoteArticles, error) in
                if let _ = error {
                    self?.fetchLocalArticles(callback: callback)
                    return
                }
            
                self?.storeRemoteArticles(using: remoteArticles, callback: callback)
                self?.fetchLocalArticles(callback: callback)
            }
        }
    }
    
    // Get dictionary of news sorted by sources
    func newsBySectionAndValues(callback: @escaping ([NewsObject]) -> Void) {
        news { [weak self] news in
            let newsDictionary = self?.newsDictionary(from: news) ?? []
            callback(newsDictionary)
        }
    }
    
    // Resave entity
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
    
    // Fetch news dictionary from CoreData with predicate
    func newsDictionaryWithPredicate(predicate: String, callback: @escaping ([NewsObject]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntitiesWithPredicate(predicate: predicate) ?? []
            let newsBySource = self?.newsDictionary(from: articleEntities.compactMap { $0.toArticle()} ) ?? []
            
            callback(newsBySource)
        }
    }
    
    // Fetch sorted news array by title from CoreData with predicate
    func sortedNewsWithPredicate(predicate: String, callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntitiesWithPredicate(predicate: predicate) ?? []
            let articles = articleEntities.compactMap { $0.toArticle() }.sorted { $0.publishedAt?.compare($1.publishedAt ?? Date()) == .orderedDescending }
            
            callback(articles)
        }
    }
    
    // Fetch news array from CoreData with predicate
    func newsWithPredicate(predicate: String, callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntitiesWithPredicate(predicate: predicate) ?? []
            let articles = articleEntities.compactMap { $0.toArticle() }

            callback(articles)
        }
    }
    
    // Remove entity
    func removeEntity(with url: String) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntity(with: url) ?? []

            for entity in articleEntities {
                context.delete(entity)
            }
            
            try? context.save()
        }
    }
    
    // MARK: - Private methods
    
    private func newsDictionary(from array: [Article]) -> [NewsObject] {
        let newsBySource = Dictionary(grouping: array, by: { $0.sourceName })
        
        var newsObjects = [NewsObject]()
        
        for (key, value) in newsBySource {
            newsObjects.append(NewsObject(sectionName: key, sectionObjects: value))
        }
        
        let sortedNewsObjectsByKeys = newsObjects.sorted { $0.sourceName?.compare($1.sourceName ?? "") == .orderedAscending }
        
        return sortedNewsObjectsByKeys
    }
    
    private func fetchArticleEntity(with url: String) -> [ArticleEntity] {
        let context = coreDataManager.context
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: String(describing: ArticleEntity.self))
    
        fetchRequest.predicate = NSPredicate(format: "url = %@", url)
    
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    private func fetchArticleEntitiesWithPredicate(predicate: String) -> [ArticleEntity] {
        let context = coreDataManager.context
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: String(describing: ArticleEntity.self))
        
        fetchRequest.predicate = NSPredicate(format: "details contains[c] %@ OR title contains[c] %@", predicate, predicate)
        
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    private func fetchLocalArticles(callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            let articles = articleEntities.compactMap { $0.toArticle() }.sorted { $0.publishedAt?.compare($1.publishedAt ?? Date()) == .orderedDescending }
            
            callback(articles)
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
