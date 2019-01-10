//
//  NewsObject.swift
//  News
//
//  Created by Dzmitry Bosak on 11/13/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

public final class NewsObject {
    
    // MARK: - Properties
    
    let sourceName: String?
    var news: [ArticleModel]?
    
    // MARK: - Initialization
    
    init(sectionName: String?, sectionObjects: [ArticleModel]? = [StubArticle]()) {
        self.sourceName = sectionName
        self.news = sectionObjects
    }
}
