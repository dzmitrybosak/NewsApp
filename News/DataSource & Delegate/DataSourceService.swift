//
//  DataSourceService.swift
//  News
//
//  Created by Dzmitry Bosak on 12/27/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

public final class DataSourceService {
    init(dataSource: NewsDataSource = NewsDataSource(), delegate: NewsTableViewDelegate = NewsTableViewDelegate()) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.delegate.dataSourceDelegate = self.dataSource
    }

    let dataSource: NewsDataSource
    let delegate: NewsTableViewDelegate
}
