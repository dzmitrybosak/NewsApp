//
//  NewsDataSource.swift
//  News
//
//  Created by Dzmitry Bosak on 11/16/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol NewsHeadersDataSource: class {
    func getHeader(by section: Int) -> String
}

final class NewsDataSource: NSObject, UITableViewDataSource {
    
    private struct Constants {
        static let cell = "TableNewsCell"
    }
    
    // MARK: - Initialization
    
//    init(_ newsService: NewsService = NewsService.shared, _ newsTableViewDelegate: NewsTableViewDelegate = NewsTableViewDelegate()) {
//        self.newsService = newsService
//        self.newsTableViewDelegate = newsTableViewDelegate
//        super.init()
//        self.newsTableViewDelegate.delegate = self
//    }
//    private let newsTableViewDelegate: NewsTableViewDelegate

    init(_ newsService: NewsService = NewsService.shared) {
        self.newsService = newsService
        super.init()
    }

    // MARK: - Properties

    private let newsService: NewsService
    
    private var newsDidLoad: Bool = false
    
    var newsBySource: [NewsObjects] = []
    var filteredNewsBySource: [NewsObjects] = []
    
    // MARK: - Main methods
    
    // Load data
    func loadData(completion: @escaping (Bool) -> Void) {
        newsService.newsBySectionAndValues { [weak self] newsObject in
            self?.newsBySource = newsObject
            self?.filteredNewsBySource = self?.newsBySource ?? []
            self?.newsDidLoad = true
            
            completion(self?.newsDidLoad ?? false)
        }
    }
    
    // Get items with predicate for search
    func getItems(with predicate: String, completion: @escaping () -> Void) {
        newsService.newsDictionaryWithPredicate(predicate: predicate) { [weak self] news in
            self?.filteredNewsBySource = news
            
            completion()
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredNewsBySource.count
    }
    
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionObjects = filteredNewsBySource[section].news else {
            return 0
        }
        
        return sectionObjects.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath) as? TableNewsCell,
            let article = filteredNewsBySource[indexPath.section].news?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.configure(with: article)
        
        return cell
    }
    
    // Editing cell style
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let url = filteredNewsBySource[indexPath.section].news?[indexPath.row].url?.absoluteString else {
            return
        }
        
        switch editingStyle {
        case .delete:
            filteredNewsBySource.remove(at: indexPath.row)
            filteredNewsBySource.remove(at: indexPath.row)
            
            newsService.removeEntity(with: url)
            //tableView.deleteRows(at: [indexPath], with: .left)
        default:
            break
        }
    }
}

// MARK: - ArticleViewControllerDelegate

extension NewsDataSource: ArticleViewControllerDelegate {
    func didLiked(_ article: Article) {
        /*guard let index = news.index(where: { $0.url == article.url } ) else {
         return
         }
         news[index] = article*/
        
//        let arraysInArray = newsBySource.map { $0.news }
    }
}

// MARK: - NewsHeadersDataSource

extension NewsDataSource: NewsHeadersDataSource {
    func getHeader(by section: Int) -> String {
        return filteredNewsBySource[section].sourceName ?? "Unknown source"
    }
}
