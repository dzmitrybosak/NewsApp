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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var imageOverlayView = UIView()
    
    var article: Article? {
        didSet {
            update()
        }
    }
    
    private func update() {
        titleLabel.text = article?.title
        
        addOverlay()
        
        if article?.urlToImage != nil {
            imageView.af_setImage(withURL: (article?.urlToImage)!, placeholderImage: UIImage(named: Constants.imageHolder))
        } else {
            imageView.image = UIImage(named: Constants.imageHolder)
        }
    }
    
    private func addOverlay() {
        imageOverlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        imageOverlayView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.addSubview(imageOverlayView)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageOverlayView.removeFromSuperview()
        imageView.af_cancelImageRequest()
        imageView.image = UIImage(named: Constants.imageHolder)
    }
    
}
