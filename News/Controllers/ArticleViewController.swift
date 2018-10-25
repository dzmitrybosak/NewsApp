//
//  ArticleVC.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

private enum Constants {
    static let imageHolder = "placeholder"
}

private enum Segues: String {
    case showWebView = "showWebView"
}

//private enum Like: Int {
//    case isDisliked = -1
//    case isLiked = 1
//}

class ArticleViewController: UIViewController {

    private let dateFormatService = DateFormatService.shared
    private let newsService = NewsService.shared
    
    // MARK: - Properties
    
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
        
        navigationItem.title = article.sourceName
        titleLabel.text = article.title
        textView.text = article.description
        
        if let unwrapedPublishedAt = article.publishedAt {
            dateLabel.text = dateFormatService.fromDate(unwrapedPublishedAt)
        }
        
        if let unwrapedURLToImage = article.urlToImage {
            imageView.af_setImage(withURL: unwrapedURLToImage, placeholderImage: UIImage(named: Constants.imageHolder))
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
//        switch likeValue {
//        case Like.isLiked.rawValue:
//            likeButton.isEnabled = true
//            dislikeButton.isEnabled = false
//        case Like.isDisliked.rawValue:
//            dislikeButton.isEnabled = true
//            likeButton.isEnabled = false
//        default:
//            break
//        }
    }
    
    private func likeSelected() {
        guard let article = article else {
            return
        }
        article.likeValue = .isLiked
//        article.likeValue = Like.isLiked.rawValue
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
        }
        
        checkLikeValue()
    }
    
    private func dislikeSelected() {
        guard let article = article else {
            return
        }
        
        article.likeValue = .isDisliked
//        article.likeValue = Like.isDisliked.rawValue
        
        newsService.resaveEntity(using: article) { [weak self] article in
            self?.article = article
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
            guard let article = article, let destination = segue.destination as? WebVC else {
                return
            }
            
            destination.url = article.url
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        likeSelected()
    }
    
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        dislikeSelected()
    }
    
    @IBAction func readMoreButton(_ sender: UIButton) {}
}
