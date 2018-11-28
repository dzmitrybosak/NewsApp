//
//  TopArticleViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 11/28/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

//struct Nib {
//    static let name = "TopArticleScreen"
//}

class TopArticleViewController: UIViewController {
    
    private var topArticle: Article?
    
    private let newsService = NewsService.shared

    private let topArticleCell = TopArticleCell()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNib()
        loadTopArticle()
    }
    
    private func loadTopArticle() {
        newsService.news { [weak self] news in
            self?.topArticle = news.first
        }
    }
    
    private func setupNib() {
        //let topArticleScreenNib = UINib(nibName: Nib.name, bundle: nil)
        
//        if let topArticleView = Bundle.main.loadNibNamed(Nib.name, owner: self, options: nil)?.first as? TopArticleCell {
//            view.addSubview(topArticleView)
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":topArticleView]))
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":topArticleView]))
//        }
        
        let topArticleView = TopArticleCell.instanceFromNib()
        view.addSubview(topArticleView)
        
    }
    
    private func setupScreen(with topArticle: Article) {
        topArticleCell.configure(with: topArticle)
    }

    // MARK: - Navigation



}
