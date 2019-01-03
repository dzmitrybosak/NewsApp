//
//  ArticleModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/22/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

protocol ArticleModel {
    var sourceName: String? { get set }
    var sourceID: String? { get set }
    var author: String? { get set }
    var title: String? { get set }
    var description: String? { get set }
    var url: URL? { get set }
    var urlToImage: URL? { get set }
    var publishedAt: Date? { get set }
    var likeValue: Article.Like { get set }
    
    init(sourceName: String?, sourceID: String?, author: String?, title: String?, description: String?, url: URL?, urlToImage: URL?, publishedAt: Date?, likeValue: Article.Like)
}
