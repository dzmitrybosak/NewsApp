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
    
    init(viewModel: ArticleViewModelProtocol = ArticleViewModel(), router: ArticleRouterProtocol = ArticleViewRouter()) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ArticleViewModel()
        router = ArticleViewRouter()
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
    
    var viewModel: ArticleViewModelProtocol?
    var router: ArticleRouterProtocol?
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router?.viewModel = viewModel
        
        setupData()
    }
    
    // MARK: - Private methods
    
    private func setupData() {
        navigationItem.title = ""
        sourceNameLabel.text = viewModel?.sourceName
        authorLabel.text = viewModel?.author
        titleLabel.text = viewModel?.title
        textView.text = viewModel?.description
        dateLabel.text = viewModel?.date
        
        guard let imageURL = viewModel?.imageURL else {
            return
        }
        
        imageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        setupReadMoreButton()
        checkLikeValue()
    }
    
    private func setupReadMoreButton() {
        guard viewModel?.url == nil else {
            return
        }
        
        readMoreButtonOutlet.isHighlighted = true
        readMoreButtonOutlet.isUserInteractionEnabled = false
    }
    
    private func checkLikeValue() {
        guard let likeValue = viewModel?.article?.likeValue else {
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.perform(segue, sender)
    }
    
    // MARK: - Actions
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        viewModel?.likeSelected { [weak self] in
            self?.checkLikeValue()
        }
        
    }
    
    @IBAction private func dislikeButtonPressed(_ sender: UIButton) {
        viewModel?.dislikeSelected { [weak self] in
            self?.checkLikeValue()
        }
    }
    
    @IBAction private func readMoreButton(_ sender: UIButton) {}
}
