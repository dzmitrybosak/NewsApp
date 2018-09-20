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
    
    var article: Article? {
        didSet {
            update()
        }
    }
    
    private func update() {
        titleLabel.text = article?.title
        
        if article?.urlToImage != nil {
            imageView.af_setImage(withURL: (article?.urlToImage)!, placeholderImage: UIImage(named: Constants.imageHolder))
        } else {
            imageView.image = UIImage(named: Constants.imageHolder)
        }
    }
    
    // Закругленные ячейки
    override func awakeFromNib() {
        super.awakeFromNib()        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.af_cancelImageRequest()
        imageView.image = UIImage(named: Constants.imageHolder)
    }
    
}
