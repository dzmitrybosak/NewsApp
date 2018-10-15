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
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: Date?
    
    @NSManaged public var likeValue: Int16
}
