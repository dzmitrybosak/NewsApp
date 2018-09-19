//
//  LikeEntity+CoreDataProperties.swift
//  News
//
//  Created by Dzmitry Bosak on 9/17/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//
//

import CoreData

extension LikeEntity {
    @NSManaged public var isLiked: Bool
    @NSManaged public var isDisliked: Bool
    
    @NSManaged public var toArticleEntity: ArticleEntity?
}
