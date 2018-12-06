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
    
    init(dataSource: NewsDataSource = NewsDataSource.shared) {
        self.dataSource = dataSource
        self.headersDataSource = self.dataSource
        super.init()
    }
    
    // MARK: - Properties
    
    private let dataSource: NewsDataSource
    
    weak var headersDataSource: NewsHeadersDataSource?
    
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
            let sourceName = headersDataSource?.getHeader(by: section) else {
                return UIView()
        }
        
        view.configure(with: sourceName)

        return view
    }
    
}
