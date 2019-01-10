//
//  StubArticle.swift
//  News
//
//  Created by Dzmitry Bosak on 12/21/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

public final class StubArticle: ArticleModel {
    init(sourceName: String?, sourceID: String?, author: String?, title: String?, description: String?, url: URL?, urlToImage: URL?, publishedAt: Date?, likeValue: Article.Like = .noLike) {
        self.sourceName = sourceName
        self.sourceID = sourceID
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.likeValue = likeValue
    }
    
    let sourceName: String?
    let sourceID: String?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
    var likeValue: Article.Like
}
