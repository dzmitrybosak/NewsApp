//
//  SectionFooter.swift
//  News
//
//  Created by Dzmitry Bosak on 11/15/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class SectionFooter: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    // MARK: - Main methods
    
    // Configure cell
    func configure(with newsCount: String) {
        setupText(from: newsCount)
    }
    
    // MARK: - Private methods
    
    private func setupText(from newsCount: String) {
        footerLabel.text = "News count by source:"
        countLabel.text = newsCount
    }

}
