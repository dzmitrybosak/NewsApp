//
//  NewsCellViewModel.swift
//  News
//
//  Created by Dzmitry Bosak on 12/18/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol NewsCellViewModelProtocol {
    var title: String? { get }
    var imageURL: URL? { get }
    func configureData(with article: Article)
}

final class NewsCellViewModel: NewsCellViewModelProtocol {

    // MARK: - Properties
    
    var title: String?
    var imageURL: URL?
    
    // MARK: - Main method
    
    func configureData(with article: Article) {
        setupText(from: article)
        setupImageURL(from: article)
    }
    
    // MARK: - Private methods
    
    private func setupText(from article: Article) {
        title = article.title
    }
    
    private func setupImageURL(from article: Article) {
        imageURL = article.urlToImage
    }
    
}
