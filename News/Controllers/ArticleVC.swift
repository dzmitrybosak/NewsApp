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

private enum Like: Int16 {
    case isLiked = 1
    case noLike = 0
    case isDisliked = -1
}

class ArticleVC: UIViewController {

    private let dateConverter = DateConverter.shared
    private let newsService = NewsService.shared //
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readMoreButtonOutlet: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
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
        
        navigationItem.title = article.name
        titleLabel.text = article.title
        textView.text = article.description
        
        if let unwrapedDate = article.publishedAt {
            dateLabel.text = dateConverter.fromDate(unwrapedDate)
        }
        
        if let unwrapedURLToImage = article.urlToImage {
            imageView.af_setImage(withURL: unwrapedURLToImage, placeholderImage: UIImage(named: Constants.imageHolder))
        }
        
        checkURLAndSetButton()
        checkLikeValue()
    }
    
    private func checkURLAndSetButton() {
        if article?.url == nil {
            readMoreButtonOutlet.isHighlighted = true
            readMoreButtonOutlet.isUserInteractionEnabled = false
        }
    }
    
    private func checkLikeValue() {
        print("Article like value is: \(String(describing: article?.likeValue))")
        
        guard let likeValue = article?.likeValue else { return }
        
        switch likeValue {
        case Like.isLiked.rawValue:
            likeButton.isEnabled = true
            dislikeButton.isEnabled = false
        case Like.isDisliked.rawValue:
            dislikeButton.isEnabled = true
            likeButton.isEnabled = false
        default:
            break
        }
    }
    
    private func likeSelected() {
        print("Like button pressed")
        
        article?.likeValue = Like.isLiked.rawValue
        
        newsService.resaveEntity(using: article!) { [weak self] _ in
            _ = self?.article
        } //
        
        checkLikeValue()
    }
    
    private func dislikeSelected() {
        print("Dislike button pressed")
        
        article?.likeValue = Like.isDisliked.rawValue
        
        newsService.resaveEntity(using: article!) { [weak self] _ in
            _ = self?.article
        } //
        
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
