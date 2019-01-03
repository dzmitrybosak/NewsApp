//
//  Router.swift
//  News
//
//  Created by Dzmitry Bosak on 12/21/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol Router {
    var viewController: UIViewController? { get set }
    func openArticleViewController(with article: ArticleModel, with newsService: NewsService)
    func openWebViewController(with url: URL)
}
