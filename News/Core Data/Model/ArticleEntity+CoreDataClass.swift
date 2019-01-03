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

    class func create(from article: ArticleModel, in context: NSManagedObjectContext) -> ArticleEntity? {
        let articleEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: ArticleEntity.self), into: context) as? ArticleEntity
        articleEntity?.sourceID = article.sourceID
        articleEntity?.sourceName = article.sourceName
        articleEntity?.author = article.author
        articleEntity?.title = article.title
        articleEntity?.details = article.description
        articleEntity?.url = article.url?.absoluteString
        articleEntity?.urlToImage = article.urlToImage?.absoluteString
        articleEntity?.publishedAt = article.publishedAt
        
        articleEntity?.likeValue = article.likeValue.rawValue
  
        return articleEntity
    }
    
    func toArticle() -> ArticleModel? {
        return Article(from: self)
    }
    
}

private extension Article {
    
    convenience init?(from entity: ArticleEntity) {
        self.init()
        sourceID = entity.sourceID ?? ""
        sourceName = entity.sourceName ?? ""
        author = entity.author ?? ""
        title = entity.title ?? ""
        description = entity.details ?? ""
        url = URL(string: entity.url ?? "")
        urlToImage = URL(string: entity.urlToImage ?? "")
        publishedAt = entity.publishedAt ?? nil
        
        likeValue = Article.Like(rawValue: entity.likeValue) ?? .noLike
    }
}
