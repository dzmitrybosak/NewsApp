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

final class NewsDataSource: NSObject {
    
    // MARK: - Initialization
    
    init(newsService: NewsService = NewsService.shared) {
        self.newsService = newsService
        super.init()
    }
    
    // MARK: - Properties
    
    private let newsService: NewsService
    
    var newsBySource: [NewsObject] = []
    var filteredNewsBySource: [NewsObject] = []
    
    // MARK: - Methods
    
    // Load data
    func loadData(completion: @escaping (Bool) -> Void) {
        newsService.newsBySectionAndValues { [weak self] newsObject in
            self?.newsBySource = newsObject
            self?.filteredNewsBySource = self?.newsBySource ?? []
            
            completion(true)
        }
    }
    
    // Get articles with predicate for search
    func getItems(with predicate: String, completion: @escaping () -> Void) {
        newsService.newsDictionaryWithPredicate(predicate: predicate) { [weak self] news in
            self?.filteredNewsBySource = news
            
            completion()
        }
    }
    
    // MARK: - Private methods
    
    // Update newsBySource array after deleting row
    private func reloadData() {
        newsService.newsBySectionAndValues { [weak self] newsObjects in
            self?.newsBySource = newsObjects
        }
    }
    
    // Remove article at indexPath
    private func removeItem(at indexPath: IndexPath) {
        
        guard let url = filteredNewsBySource[indexPath.section].news?[indexPath.row].url?.absoluteString else {
            return
        }
        
        newsBySource.remove(at: indexPath.row)
        reloadData()
        
        filteredNewsBySource[indexPath.section].news?.remove(at: indexPath.row)
        newsService.removeEntity(with: url)
    }
    
}


// MARK: - UITableViewDataSource

extension NewsDataSource: UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableNewsCell.reuseIdentifier, for: indexPath) as? TableNewsCell,
              let article = filteredNewsBySource[indexPath.section].news?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.configure(with: article)
        
        return cell
    }
    
    // Editing cell style
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        default:
            break
        }
    }
    
}

// MARK: - ArticleViewControllerDelegate

extension NewsDataSource: ArticleViewControllerDelegate {
    
    func didLiked(_ article: Article) {
        let section = newsBySource.index(where: { $0.sourceName == article.sourceName } ) ?? 0
        let row = newsBySource[section].news?.index(where: { $0.url == article.url } ) ?? 0
        newsBySource[section].news?[row].likeValue = article.likeValue
    }
    
}

// MARK: - NewsHeadersDataSource

extension NewsDataSource: NewsHeadersDataSource {
    
    func getHeader(by section: Int) -> String {
        return filteredNewsBySource[section].sourceName ?? "Unknown source"
    }
    
}
