//
//  ArticleEntity+CoreDataClass.swift
//  News
//
//  Created by Dzmitry Bosak on 9/4/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//
//

import CoreData

@objc(ArticleEntity)
public class ArticleEntity: NSManagedObject {

    class func create(from article: Article, in context: NSManagedObjectContext) -> ArticleEntity? {
        let articleEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: ArticleEntity.self), into: context) as? ArticleEntity
        articleEntity?.id = article.id
        articleEntity?.name = article.name
        articleEntity?.author = article.author
        articleEntity?.title = article.title
        articleEntity?.details = article.description
        articleEntity?.url = article.url?.absoluteString
        articleEntity?.urlToImage = article.urlToImage?.absoluteString
        articleEntity?.publishedAt = article.publishedAt
        
        articleEntity?.likeValue = article.likeValue
  
        return articleEntity
    }
    
    func map() -> Article? {
        return Article(from: self)
    }
}

private extension Article {
    
    init?(from entity: ArticleEntity) {
       
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.author = entity.author ?? ""
        self.title = entity.title ?? ""
        self.description = entity.details ?? ""
        self.url = URL(string: entity.url ?? "")
        self.urlToImage = URL(string: entity.urlToImage ?? "")
        self.publishedAt = entity.publishedAt ?? nil
        
        self.likeValue = entity.likeValue
    }
}
