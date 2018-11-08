//
//  TableNewsCell.swift
//  News
//
//  Created by Dzmitry Bosak on 11/5/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

final class TableNewsCell: UITableViewCell {

    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageCellView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageCellView.af_cancelImageRequest()
    }
    
    func configure(with article: Article) {
        sourceLabel.text = article.sourceName
        titleLabel.text = article.title
        
        imageCellView.layer.cornerRadius = 5
        
        if let urlToImage = article.urlToImage {
            imageCellView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        else {
            imageCellView.image = #imageLiteral(resourceName: "placeholder")
        }
        
        // Set selection background color
        let selectionView = UIView()
        selectionView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        selectedBackgroundView = selectionView
    }
    
}
