//
//  ArticleModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/22/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

protocol ArticleModel {
    var sourceName: String? { get }
    var sourceID: String? { get }
    var author: String? { get }
    var title: String? { get }
    var description: String? { get }
    var url: URL? { get }
    var urlToImage: URL? { get }
    var publishedAt: Date? { get }
    var likeValue: Article.Like { get set }
}
