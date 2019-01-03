//
//  StubService.swift
//  News
//
//  Created by Dzmitry Bosak on 12/22/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class StubService: NewsServiceProtocol {
    func getNews(callback: @escaping NewsCallback) {
        let news = [
            Article(sourceName: "raywenderlich.com", sourceID: "raywenderlich.com", author: "Matthew Morey", title: "Multiple Managed Object Contexts with Core Data Tutorial", description: "Learn how to use multiple managed object contexts to improve the performance of your apps in this Core Data Tutorial in Swift!", url: URL(string: "https://www.raywenderlich.com/7586-multiple-managed-object-contexts-with-core-data-tutorial"), urlToImage: URL(string: "https://koenig-media.raywenderlich.com/uploads/2016/10/CDT-feature-3.png"), publishedAt: Date(), likeValue: .noLike),
            Article(sourceName: "BBC", sourceID: "BBC", author: "Harry", title: "Hello world", description: "ggdgdsgrdg gsgrersg", url: URL(string: ""), urlToImage: nil, publishedAt: Date(), likeValue: .isLiked),
            Article(sourceName: "CNN", sourceID: "CNN", author: "Alex", title: "All About Routing in Clean Swift", description: "Since I started talking about Clean Swift iOS architecture, I’ve received a lot of positive feedback. Many people have downloaded my Xcode templates and put them to good use. I am truly grateful that I am able to help you write better apps.", url: URL(string: "https://clean-swift.com/routing-in-clean-swift/"), urlToImage: URL(string: "https://clean-swift.com/wp-content/uploads/2015/08/Swift.png"), publishedAt: Date(), likeValue: .isDisliked)
        ]
        callback(news, nil)
    }
}
