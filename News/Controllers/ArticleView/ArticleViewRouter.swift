//
//  ArticleViewRouter.swift
//  News
//
//  Created by Dzmitry Bosak on 12/20/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol ArticleRouterProtocol {
    var viewModel: ArticleViewModelProtocol? { get set }
    func perform(_ segue: UIStoryboardSegue, _ sender: Any?)
}

class ArticleViewRouter: ArticleRouterProtocol {
    
    private enum Segues: String {
        case showWebView = "showWebView"
    }
    
    var viewModel: ArticleViewModelProtocol?
    
    func perform(_ segue: UIStoryboardSegue, _ sender: Any?) {
  
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showWebView.rawValue:
            guard let url = viewModel?.url, let destination = segue.destination as? WebViewController else {
                return
            }
            
            destination.url = url
        default:
            break
        }
        
    }
    
}
