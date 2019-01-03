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
    func configure(with: ArticleModel)
}

final class ArticlePreviewView: UIView, Configuration {
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties
    
    weak var action: Action?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backgroundArticleView: UIView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var descriptionArticleLabel: UILabel!
    @IBOutlet private weak var imageArticleView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Overrided methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configure(with article: ArticleModel) {
        setupText(from: article)
        setupImage(from: article)
    }
    
    // MARK: - Private methods
    
    // For data
    
    private func setupText(from article: ArticleModel) {
        titleArticleLabel.text = article.title
        descriptionArticleLabel.text = article.description
    }
    
    private func setupImage(from article: ArticleModel) {
        
        if let urlToImage = article.urlToImage {
            imageArticleView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            imageArticleView.image = #imageLiteral(resourceName: "placeholder")
        }
        
    }
    
    // For views
    
    func configureView() {
        titleArticleLabel.text = nil
        descriptionArticleLabel.text = nil
        imageArticleView.image = nil
        
        setupCornerRadius(for: backgroundArticleView)
        setupShadow(for: backgroundArticleView)
        setupRoundedButton(for: closeButton)
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
    
    @IBAction func toArticle(_ sender: UIButton) {
        action?.openArticle()
    }
    
    @IBAction func closeArticle(_ sender: UIButton) {
        action?.close()
    }
    
}

// MARK: - UIView

extension UIView {
    
    // Loads instance from nib with the same name
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}
