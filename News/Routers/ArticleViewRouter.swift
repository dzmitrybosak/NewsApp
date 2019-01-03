//
//  ArticleViewRouter.swift
//  News
//
//  Created by Dzmitry Bosak on 12/20/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class ArticleViewRouter: Router {
    
    weak var viewController: UIViewController?
    
    func openWebViewController(with url: URL) {
        let webViewController = WebViewController()
        webViewController.url = url
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func openArticleViewController(with article: ArticleModel, with newsService: NewsService) { }
}
