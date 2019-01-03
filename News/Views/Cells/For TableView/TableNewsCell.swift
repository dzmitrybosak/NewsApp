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

    class var reuseIdentifier: String {
        return "TableNewsCell"
    }
    
    // MARK: - Properties
    
    var viewModel: NewsCellViewModelProtocol?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageCellView: UIImageView!
    
    // MARK: - UITableViewCell methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.af_cancelImageRequest()
    }
    
    // MARK: - Data method
    
    func setupData() {
        
        titleLabel.text = self.viewModel?.title
        
        guard let imageURL = viewModel?.imageURL else {
            return
        }
        
        imageCellView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        setupSelectionColor()
        setupCornerRadius(for: imageCellView)
    }
    
    private func setupCornerRadius(for imageView: UIImageView) {
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
    }
    
    private func setupSelectionColor() {
        let selectionView = UIView()
        selectionView.backgroundColor = #colorLiteral(red: 0.200000003, green: 0.200000003, blue: 0.200000003, alpha: 1)
        selectedBackgroundView = selectionView
    }
}
