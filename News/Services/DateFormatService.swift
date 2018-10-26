//
//  DateConverter.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class DateFormatService {
 
    static let shared = DateFormatService()
    private init() {}
    
    func fromDate(_ publishedAt: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let dateString = dateFormatter.string(from: publishedAt)

        return dateString
    }
}
