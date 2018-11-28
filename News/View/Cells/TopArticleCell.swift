//
//  TopArticleCell.swift
//  News
//
//  Created by Dzmitry Bosak on 11/27/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

final class TopArticleCell: TableNewsCell {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TopArticleScreen", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView ?? UIView()
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backgroundArticleView: UIView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var descriptionArticleLabel: UILabel!
    @IBOutlet private weak var imageArticleView: UIImageView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // TODO: - Tap Gesture Recognizer
    
    // TODO: - Service or ViewController or Service + ViewController
    
    // MARK: - Overrided methods
    
    override func awakeFromNib() {
        setupCornerRadius(for: backgroundArticleView)
        setupShadow(for: backgroundArticleView)
        setupRoundedButton(for: cancelButton)
    }
    
    override func prepareForReuse() {
        imageArticleView.af_cancelImageRequest()
    }
    
    override func configure(with article: Article) {
        setupText(from: article)
        setupImage(from: article)
    }
    
    override func setupText(from article: Article) {
        titleArticleLabel.text = article.title
        descriptionArticleLabel.text = article.description
    }
    
    override func setupImage(from article: Article) {
        
        if let urlToImage = article.urlToImage {
            imageArticleView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            imageArticleView.image = #imageLiteral(resourceName: "placeholder")
        }
        
    }
    
    override func setupCornerRadius(for view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    // MARK: - Private methods
    
    // For views
    
    private func setupRoundedButton(for button: UIButton) {
        button.layer.cornerRadius = button.bounds.size.width / 2.0
        button.clipsToBounds = true
    }
    
    private func setupShadow(for view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
    }
    
    // For actions
    
    private func dismissArticle() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func closeArticle(_ sender: UIButton) {
        dismissArticle()
    }

    // MARK: - Navigation
    // TODO: - Push or smth to ArticleViewController
    
}
