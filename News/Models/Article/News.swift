//
//  News.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class News: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case news = "articles"
    }
    
    var news: [Article]
}
