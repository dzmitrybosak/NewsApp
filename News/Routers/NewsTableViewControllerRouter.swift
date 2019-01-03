//
//  NewsTableViewControllerRouter.swift
//  News
//
//  Created by Dzmitry Bosak on 12/21/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class NewsTableViewControllerRouter: Router {
    
    weak var viewController: UIViewController?
    
    func openArticleViewController(with article: ArticleModel, with newsService: NewsService) {
        let articleViewRouter = ArticleViewRouter()
        let articleViewModel = ArticleViewModel(newsService: newsService, router: articleViewRouter)
        let articleViewController = ArticleViewController(dateFormatService: DateFormatService.shared, viewModel: articleViewModel)
        articleViewModel.article = article
        viewController?.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func openWebViewController(with url: URL) {}
}
