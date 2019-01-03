//
//  Article.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class Article: ArticleModel, Decodable {
    
    // MARK: - Properties
    
    var sourceName: String?
    var sourceID: String?

    var author: String?
    var title: String?
    var description: String?
    var url: URL?
    var urlToImage: URL?
    var publishedAt: Date?
    var likeValue: Like
    
    enum Like: Int {
        case isLiked = 1
        case noLike = 0
        case isDisliked = -1
    }
    
    // MARK: - Keys for decoding
    
    enum CodingKeys: String, CodingKey {
        case source
        case sourceID = "id"
        case sourceName = "name"
        
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
    
    // MARK: - Initialization
    
    convenience init(sourceName: String?, sourceID: String?, author: String?, title: String?, description: String?, url: URL?, urlToImage: URL?, publishedAt: Date?, likeValue: Article.Like) {
        self.init()
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
    
    init() {
        self.sourceName = ""
        self.sourceID = ""
        self.author = ""
        self.title = ""
        self.description = ""
        self.url = URL(string: "")
        self.urlToImage = URL(string: "")
        self.publishedAt = Date()
        self.likeValue = Like.noLike
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let source = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .source)
        self.sourceID = try? source.decode(String.self, forKey: .sourceID)
        self.sourceName = try? source.decode(String.self, forKey: .sourceName)
        
        self.author = try? container.decode(String.self, forKey: .author)
        self.title = try? container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)
        self.url = try? container.decode(URL.self, forKey: .url)
        self.urlToImage = try? container.decode(URL.self, forKey: .urlToImage)
        self.publishedAt = try? container.decode(Date.self, forKey: .publishedAt)
        
        self.likeValue = Like.noLike
    }
}
