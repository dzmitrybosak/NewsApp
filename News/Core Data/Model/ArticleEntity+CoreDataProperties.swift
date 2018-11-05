//
//  ArticleEntity+CoreDataProperties.swift
//  News
//
//  Created by Dzmitry Bosak on 9/4/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//
//

import CoreData

extension ArticleEntity {
    @NSManaged var sourceID: String?
    @NSManaged var sourceName: String?
    
    @NSManaged var author: String?
    @NSManaged var title: String?
    @NSManaged var details: String?
    @NSManaged var url: String?
    @NSManaged var urlToImage: String?
    @NSManaged var publishedAt: Date?
    
    @NSManaged var likeValue: Int
}
