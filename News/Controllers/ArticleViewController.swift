//
//  ArticleViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

private enum Segues: String {
    case showWebView = "showWebView"
}

protocol ArticleViewControllerDelegate: class {
    func didLiked(_ article: Article)
}

class ArticleViewController: UIViewController {

    private let dateFormatService = DateFormatService.shared
    private let newsService = NewsService.shared
    
    // MARK: - Properties
    
    weak var delegate: ArticleViewControllerDelegate?
    
    @IBOutlet private weak var sourceNameLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMoreButtonOutlet: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dislikeButton: UIButton!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    // MARK: - Private methods
    
    private func setupData() {
        guard let article = article else {
            return
        }
        
        navigationItem.title = ""
        sourceNameLabel.text = article.sourceName
        authorLabel.text = article.author
        titleLabel.text = article.title
        textView.text = article.description
        
        if let publishedAt = article.publishedAt {
            dateLabel.text = dateFormatService.fromDate(publishedAt)
        }
        
        if let urlToImage = article.urlToImage {
            imageView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        checkURLAndSetButton()
        checkLikeValue()
    }
    
    private func checkURLAndSetButton() {
        guard article?.url == nil else {
            return
        }
        
        readMoreButtonOutlet.isHighlighted = true
        readMoreButtonOutlet.isUserInteractionEnabled = false
    }
    
    private func checkLikeValue() {
        
        guard let likeValue = article?.likeValue else {
            return
        }
        
        switch likeValue {
        case .isLiked:
            likeButton.isEnabled = true
            dislikeButton.isEnabled = false
        case .isDisliked:
            dislikeButton.isEnabled = true
            likeButton.isEnabled = false
        default:
            break
        }
    }
    
    private func likeSelected() {
        guard let article = article else {
            return
        }
        article.likeValue = .isLiked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        checkLikeValue()
    }
    
    private func dislikeSelected() {
        guard let article = article else {
            return
        }
        
        article.likeValue = .isDisliked
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
            self?.delegate?.didLiked(article)
        }
        
        checkLikeValue()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case Segues.showWebView.rawValue:
            guard let article = article, let destination = segue.destination as? WebViewController else {
                return
            }
            
            destination.url = article.url
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        likeSelected()
    }
    
    @IBAction private func dislikeButtonPressed(_ sender: UIButton) {
        dislikeSelected()
    }
    
    @IBAction private func readMoreButton(_ sender: UIButton) {}
}
