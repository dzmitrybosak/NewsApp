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

    // MARK: - Properties
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageCellView: UIImageView!
    
    // MARK: - Main methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSelectionColor()
        setupCornerRadius(for: imageCellView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.af_cancelImageRequest()
    }
    
    // Configure cell
    func configure(with article: Article) {
        setupText(from: article)
        setupImage(from: article)
    }
    
    // MARK: - Private methods
    
    private func setupText(from article: Article) {
        titleLabel.text = article.title
    }
    
    private func setupImage(from article: Article) {
        
        if let urlToImage = article.urlToImage {
            imageCellView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            imageCellView.image = #imageLiteral(resourceName: "placeholder")
        }

    }
    
    private func setupCornerRadius(for imageView: UIImageView) {
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
    }
    
    // Setup selection background color
    private func setupSelectionColor() {
        let selectionView = UIView()
        selectionView.backgroundColor = #colorLiteral(red: 0.200000003, green: 0.200000003, blue: 0.200000003, alpha: 1)
        selectedBackgroundView = selectionView
    }
}
