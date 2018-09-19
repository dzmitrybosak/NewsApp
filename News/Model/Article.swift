//
//  Article.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

struct Article: Decodable {
    
    var name: String?
    var id: String?

    var author: String?
    var title: String?
    var description: String?
    var url: URL?
    var urlToImage: URL?
    var publishedAt: String?
    
    var like: Like
    
    enum CodingKeys: CodingKey {
        case source
        case id
        case name
        
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let source = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .source)
        self.id = try? source.decode(String.self, forKey: .id)
        self.name = try? source.decode(String.self, forKey: .name)
        
        self.author = try? container.decode(String.self, forKey: .author)
        self.title = try? container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)
        self.url = try? container.decode(URL.self, forKey: .url)
        self.urlToImage = try? container.decode(URL.self, forKey: .urlToImage)
        self.publishedAt = try? container.decode(String.self, forKey: .publishedAt)
        
        let like = Like(isLiked: false, isDisliked: false)
        self.like = like
    }
}
