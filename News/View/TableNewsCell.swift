//
//  NewsCell.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class TableNewsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var article: Article? {
        didSet {
            update()
        }
    }
    
    private func update() {
        self.textLabel?.text = article?.title
        self.detailTextLabel?.text = article?.name
    }
    
    override func prepareForReuse() {
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }
}
