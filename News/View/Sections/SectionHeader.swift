//
//  SectionHeader.swift
//  News
//
//  Created by Dzmitry Bosak on 11/15/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class SectionHeader: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    @IBOutlet private weak var headerLabel: UILabel!

    // MARK: - Main methods
    
    // Configure cell
    func configure(with sourceName: String) {
        setupText(from: sourceName)
    }
    
    // MARK: - Private methods
    
    private func setupText(from sourceName: String) {
        headerLabel.text = sourceName
    }
}
