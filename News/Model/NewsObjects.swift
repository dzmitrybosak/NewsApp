//
//  NewsObjects.swift
//  News
//
//  Created by Dzmitry Bosak on 11/13/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class NewsObjects {
    
    // MARK: - Properties
    
    var sourceName: String?
    var news: [Article]?
    
    // MARK: - Initialization
    
    init(sectionName: String?, sectionObjects: [Article]?) {
        self.sourceName = sectionName
        self.news = sectionObjects
    }
    
    init() {
        self.sourceName = nil
        self.news = nil
    }
    
}
