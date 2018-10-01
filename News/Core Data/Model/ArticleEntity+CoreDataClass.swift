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
        
        articleEntity?.likeValue = article.likeValue //
  
        return articleEntity
    }
    
    class func resaveLike(from article: Article, in context: NSManagedObjectContext) -> ArticleEntity? {
        let articleEntity = NSEntityDescription.entity(forEntityName: String(describing: ArticleEntity.self), in: context) as? ArticleEntity
        
        articleEntity?.setValue(article.likeValue, forKey: String(describing: articleEntity?.likeValue.self))
        articleEntity?.setValue(article.name, forKey: String(describing: articleEntity?.name.self))
        articleEntity?.setValue(article.id, forKey: String(describing: articleEntity?.id.self))
        articleEntity?.setValue(article.author, forKey: String(describing: articleEntity?.author.self))
        articleEntity?.setValue(article.title, forKey: String(describing: articleEntity?.title.self))
        articleEntity?.setValue(article.description, forKey: String(describing: articleEntity?.details.self))
        articleEntity?.setValue(article.url?.absoluteURL, forKey: String(describing: articleEntity?.url.self))
        articleEntity?.setValue(article.urlToImage, forKey: String(describing: articleEntity?.urlToImage.self))
        articleEntity?.setValue(article.publishedAt, forKey: String(describing: articleEntity?.publishedAt.self))
        
        return articleEntity
    }
    
    func map() -> Article? {
        return Article(from: self)
    }
}

private extension Article {
    
    init?(from entity: ArticleEntity) {
        guard let url = entity.url else {
            return nil
        }
        
        guard let urlToImage = entity.urlToImage else {
            return nil
        }
        
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.author = entity.author ?? ""
        self.title = entity.title ?? ""
        self.description = entity.details ?? ""
        self.url = URL(string: url)!
        self.urlToImage = URL(string: urlToImage)!
        self.publishedAt = entity.publishedAt ?? ""
        
        self.likeValue = entity.likeValue //
    }
}
