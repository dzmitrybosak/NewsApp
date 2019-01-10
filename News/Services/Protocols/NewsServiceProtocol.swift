//
//  NewsServiceProtocol.swift
//  News
//
//  Created by Dzmitry Bosak on 12/22/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

typealias NewsCallback = (_ news: [ArticleModel], _ error: Error?) -> Void

protocol NewsServiceProtocol {
    func getNews(callback: @escaping NewsCallback)
}
