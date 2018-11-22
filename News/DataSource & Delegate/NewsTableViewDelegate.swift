//
//  NewsTableViewDelegate.swift
//  News
//
//  Created by Dzmitry Bosak on 11/16/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class NewsTableViewDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Initialization
    
//    init(_ dataSource: NewsDataSource = NewsDataSource()) {
//        self.dataSource = dataSource
//        self.delegate = self.dataSource
//
//        super.init()
//
//    }
    
    // MARK: - Properties
    
//    private let dataSource: NewsDataSource
    
    weak var delegate: NewsHeadersDataSource?
    
    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Section.header) as? SectionHeader,
              let sourceName = delegate?.getHeader(by: section) else {
                return UIView()
        }
        
        view.configure(with: sourceName)

        return view
    }
    
     //Footer
    /*func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Section.footer) as? SectionFooter,
            let sectionObjects = filteredNewsBySource[section].news else {
                return UIView()
            }
    
        let newsCount = "\(sectionObjects.count)"
    
        view.configure(with: newsCount)
    
        return view
    }*/
    
}
