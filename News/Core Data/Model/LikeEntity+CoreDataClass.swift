//
//  LikeEntity+CoreDataClass.swift
//  News
//
//  Created by Dzmitry Bosak on 9/17/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//
//

import CoreData

@objc(LikeEntity)
public class LikeEntity: NSManagedObject {

    class func create(from article: Article, in context: NSManagedObjectContext) -> LikeEntity? {
        let likeEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: LikeEntity.self), into: context) as? LikeEntity
        likeEntity?.isLiked = article.like.isLiked
        likeEntity?.isDisliked = article.like.isDisliked
        
        return likeEntity
    }
}
