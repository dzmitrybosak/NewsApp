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
    
    // MARK: - Main method
    
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
    
    
// запуск -> загрузка новостей из интернета -> удаление старых новостей из базы -> сохранение новых новостей в базу
//                                          -> если нет соединения, то извлечение новостей из базы
//
// запуск -> загрузка новостей из интернета -> сохранение новостей в базу с проверкой (если новость есть, то не ее не сохранять) -> лайк -> пересохранение новости в базу -> извлечение новостей из базы
//                                          -> если соединения нет, то извлечение новостей базы -> лайк -> проверка на наличие таковой новости в базе. если нет, то добавить и удалить первую -> сохранить базу -> извлечение новостей из базы

    
    // resave entity
    func resaveEntity(using article: Article, callback: @escaping (Article) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            let articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
            for articleEntity in articleEntities {
                
                if article.title == articleEntity.title {
                    articleEntity.setValue(article.likeValue, forKey: "likeValue")
                }
            }
            
            try? context.save()
            
            callback(article)
        }
    }
    
    // fetch articles with likes
    // получить массив статей с сохраненными лайками
    // заменить лайки в массиве?
    func fetchLikes(callback: @escaping ([Article]) -> Void) {
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
    
    /*
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
     */
    
    // сохранить записи -> удалить все записи -> создать новые записи -> сохранить контекст -> колбэк
    // сохранить записи -> если статья уже есть, то вернуть записи -> если статьи нет, то создать и удалить первую запись ->  сохранить контекст -> колбэк
    
    private func storeRemoteArticles(using articles: [Article], callback: @escaping ([Article]) -> Void) {
        let context = coreDataManager.context
        context.perform { [weak self] in
            var articleEntities = self?.fetchArticleEntities(from: context) ?? []
            
            for article in articles {
                
                if !articleEntities.contains(where: { $0.title == article.title }) {
                    _ = ArticleEntity.create(from: article, in: context)
                } else if !articles.contains(where: { $0.title == article.title }) {
                    
                    for articleEntity in articleEntities {
                        //context.delete(articleEntity)
                    }
                }
                
                
                
            }
            
            
            
            try? context.save()
            
            print("Articles from web: \(articles.count)")
            print("Articles in CoreData \(articleEntities.count)")
            
            callback(articles)
        }
    }
    
    private func fetchArticleEntities(from context: NSManagedObjectContext) -> [ArticleEntity] {
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: String(describing: ArticleEntity.self))
        return (try? context.fetch(fetchRequest)) ?? []
    }
}
