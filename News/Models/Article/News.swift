//
//  News.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

public final class News: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case news = "articles"
    }
    
    let news: [Article]
}
