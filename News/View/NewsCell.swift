//
//  NewsCell.swift
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

class NewsCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var overlay: UIView!
    
    var article: Article? {
        didSet {
            update()
        }
    }
    
    private func update() {
        titleLabel.text = article?.title
        
        guard let urlToImage = article?.urlToImage else {
            return
        }
        
        imageView.af_setImage(withURL: urlToImage, placeholderImage: UIImage(named: Constants.imageHolder))
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.af_cancelImageRequest()
        imageView.image = UIImage(named: Constants.imageHolder)
    }
    
}
