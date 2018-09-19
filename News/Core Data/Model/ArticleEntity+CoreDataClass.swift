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
        //articleEntity?.toLikeEntity?.isLiked = article.like.isLiked
        //articleEntity?.toLikeEntity?.isDisliked = article.like.isDisliked
  
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
        
        let like = Like(isLiked: (entity.toLikeEntity?.isLiked)!, isDisliked: (entity.toLikeEntity?.isDisliked)!) //
        self.like = like //
    }
}
