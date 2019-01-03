//
//  NewsTableViewDelegate.swift
//  News
//
//  Created by Dzmitry Bosak on 11/16/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

protocol ItemSelectable: class {
    func didSelectItem(at indexPath: IndexPath)
}

final class NewsTableViewDelegate: NSObject, UITableViewDelegate  {
    
    // MARK: - Properties
    
    weak var viewModel: ItemSelectable?
    
    weak var dataSourceDelegate: DataSourceDelegate?
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectItem(at: indexPath)
    }
    
    // Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Section.header) as? SectionHeader,
            let sourceName = dataSourceDelegate?.getHeader(by: section) else {
                return UIView()
        }
        
        view.configure(with: sourceName)

        return view
    }
    
}
