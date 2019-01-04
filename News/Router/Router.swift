//
//  Router.swift
//  News
//
//  Created by Dzmitry Bosak on 12/21/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol Router {
    func setupViewController(with viewController: UIViewController)
    func perform(route: Route)
}

enum Route {
    case articleViewController(ArticleModel, NewsService)
    case webViewController(URL)
}

public final class MainRouter: Router {
    
    weak var viewController: UIViewController?
    
    func setupViewController(with viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func perform(route: Route) {
        switch route {
        case .articleViewController(let article, let newsService):
            openArticleViewController(with: article, with: newsService)
        case .webViewController(let url):
            openWebViewController(with: url)
        }
        
    }
    
    func openArticleViewController(with article: ArticleModel, with newsService: NewsService) {
        let articleViewModel = ArticleViewModel(newsService: newsService, router: self)
        let articleViewController = ArticleViewController(dateFormatService: DateFormatService.shared, viewModel: articleViewModel)
        articleViewModel.article = article
        viewController?.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func openWebViewController(with url: URL) {
        let webViewController = WebViewController()
        webViewController.url = url
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
}
