//
//  ArticleViewController.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

class ArticleViewController: UIViewController {
    
    // MARK: - Initialization
    
    init(dateFormatService: DateFormatService, viewModel: ArticleViewModelProtocol) {
        self.dateFormatService = dateFormatService
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        dateFormatService = DateFormatService.shared
        viewModel = ArticleViewModel(newsService: NewsService(), router: ArticleViewRouter())
        super.init(coder: aDecoder)
    }
    
    // MARK: - Outlets
    
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
    
    // MARK: - Properties
    
    var viewModel: ArticleViewModelProtocol
    private let dateFormatService: DateFormatService

    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.router.viewController = self
        
        setupData()
    }
    
    // MARK: - Private methods
    
    private func setupData() {
        navigationItem.title = ""
        
        guard let article = viewModel.article else {
            return
        }

        sourceNameLabel.text = article.sourceName
        authorLabel.text = article.author
        titleLabel.text = article.title
        textView.text = article.description

        setupReadMoreButton()
        checkLikeValue()

        if let publishedAt = article.publishedAt {
            dateLabel.text = dateFormatService.fromDate(publishedAt)
        }

        if let imageURL = article.urlToImage {
            imageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
    }
    
    private func setupReadMoreButton() {
        guard viewModel.article?.url == nil else {
            return
        }
        
        readMoreButtonOutlet.isHighlighted = true
        readMoreButtonOutlet.isUserInteractionEnabled = false
    }
    
    private func checkLikeValue() {
        guard let likeValue = viewModel.article?.likeValue else {
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

    // MARK: - Actions
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        viewModel.likeSelected { [weak self] in
            self?.checkLikeValue()
        }
        
    }
    
    @IBAction private func dislikeButtonPressed(_ sender: UIButton) {
        viewModel.dislikeSelected { [weak self] in
            self?.checkLikeValue()
        }
    }
    
    @IBAction private func readMoreButton(_ sender: UIButton) {
        
        guard let url = viewModel.article?.url else {
            return
        }
        
        print(url)
        
        viewModel.router.openWebViewController(with: url)
    }
}
