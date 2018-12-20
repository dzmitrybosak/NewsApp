//
//  NewsTableViewControllerRouter.swift
//  News
//
//  Created by Dzmitry Bosak on 12/20/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    var viewModel: NewNewsTableViewModelProtocol? { get set }
    func perform(_ segue: UIStoryboardSegue, _ sender: Any?)
}

class NewsTableViewControllerRouter: RouterProtocol {
    
    private enum Segues: String {
        case showArticle = "showArticle"
    }
    
    var viewModel: NewNewsTableViewModelProtocol?
    
    func perform(_ segue: UIStoryboardSegue, _ sender: Any?) {
        
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showArticle.rawValue:
            guard let newsCell = sender as? TableNewsCell,
                  let index = viewModel?.tableViewDelegate?.tableView.indexPath(for: newsCell),
                  let articleViewController = segue.destination as? ArticleViewController
                else {
                    return
            }

            let articleViewModel = ArticleViewModel()
            articleViewController.viewModel = articleViewModel
            articleViewModel.article = viewModel?.newsDataSource.filteredNewsBySource[index.section].news?[index.row]
            articleViewModel.delegate = viewModel?.newsDataSource
            articleViewModel.setupData()
            
        default:
            break
        }
        
    }
    
}

