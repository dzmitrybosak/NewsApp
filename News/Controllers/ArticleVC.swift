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

class ArticleVC: UIViewController {

    private let dateConverter = DateConverter.shared
    private let likeService = LikeService.shared
    
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
        
    }
    
    private func checkURLAndSetButton() {
        if article?.url == nil {
            readMoreButtonOutlet.isHighlighted = true
            readMoreButtonOutlet.isUserInteractionEnabled = false
        }
    }
    
    private func checkLikeValue() {
        print("Article like: \(String(describing: article?.like.isLiked.description))")
        print("Article dislike: \(String(describing: article?.like.isDisliked.description))")
        
        if article?.like.isLiked == true {
            dislikeButton.isEnabled = false
        } else if article?.like.isDisliked == true {
            likeButton.isEnabled = false
        }
    }
    
    private func likeSelected() {
        article?.like.isLiked = true
        article?.like.isDisliked = false
        
        print("Like button pressed")
        checkLikeValue()
    }
    
    private func dislikeSelected() {
        article?.like.isDisliked = true
        article?.like.isLiked = false
        
        print("Dislike button pressed")
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
    
    @IBAction func readMoreButton(_ sender: UIButton) {}
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        likeSelected()
    }
    
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        dislikeSelected()
    }
    
}
