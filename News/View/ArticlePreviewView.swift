//
//  ArticlePreviewView.swift
//  News
//
//  Created by Dzmitry Bosak on 11/27/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

protocol Configuration: class {
    func configure(with: Article)
}

final class ArticlePreviewView: UIView, Configuration {
    
    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(String(describing: ArticlePreviewView.self), owner: self, options: nil)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Class method
    
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: String(describing: ArticlePreviewView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView ?? UIView()
//    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var backgroundArticleView: UIView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var descriptionArticleLabel: UILabel!
    @IBOutlet private weak var imageArticleView: UIImageView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Overrided methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configure(with article: Article) {
        setupText(from: article)
        setupImage(from: article)
    }
    
    // MARK: - Private methods
    
    // For data
    
    private func setupText(from article: Article) {
        titleArticleLabel.text = article.title
        descriptionArticleLabel.text = article.description
    }
    
    private func setupImage(from article: Article) {
        
        if let urlToImage = article.urlToImage {
            imageArticleView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            imageArticleView.image = #imageLiteral(resourceName: "placeholder")
        }
        
    }
    
    // For views
    
    private func configureView() {
        setupCornerRadius(for: backgroundArticleView)
        setupShadow(for: backgroundArticleView)
        setupRoundedButton(for: cancelButton)
    }
    
    private func setupCornerRadius(for view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
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
    
    // MARK: - Actions
    
    @IBAction func closeArticle(_ sender: UIButton) {
        print("Close")
    }
    
}
