//
//  TableNewsCell.swift
//  News
//
//  Created by Dzmitry Bosak on 11/5/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import AlamofireImage

class TableNewsCell: UITableViewCell {

    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageCellView: UIImageView!
    
    var article: Article? {
        didSet {
            update()
        }
    }
    
    private func update() {
        
        sourceLabel.text = article?.sourceName
        titleLabel.text = article?.title
        
        guard let urlToImage = article?.urlToImage else {
            return
        }
        
        imageCellView.af_setImage(withURL: urlToImage, placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        imageCellView.af_cancelImageRequest()
        imageCellView.image = #imageLiteral(resourceName: "placeholder")
        selectedBackgroundView = nil
    }
    
    func setSelectionColor() -> UIView {
        let selectionView = UIView()
        selectionView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        return selectionView
    }
    
}
