//
//  NewsService.swift
//  News
//
//  Created by Dzmitry Bosak on 9/5/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import CoreData

final class NewsService {
    private let newsWebService = WebService.shared
    private let coreDataManager = CoreDataManager.shared
    
    static let shared = NewsService()
    private init() { }
    
    func news(callback: @escaping ([Article]) -> Void) {
        newsWebService.getNews { [weak self] (remoteArticles, error) in
            if let _ = error {
                self?.fetchLocalArticles(callback: callback)
                return
            }
            
            self?.storeRemoteArticles(using: remoteArticles, callback: callback)
        }
    }
    
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
    
    private func storeLikes() {
        
    }
    
    private func storeRemoteArticles(using articles: [Article], callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
            for articleEntity in articleEntities {
                context.delete(articleEntity)
            }
            
            for article in articles {
                _ = ArticleEntity.create(from: article, in: context)
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
