//
//  DateConverter.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class DateConverter {
 
    static let shared = DateConverter()
    private init() {}
    
    func fromDate(_ publishedAt: String) -> String {
        
        let string = publishedAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: string) else {
            fatalError()
        }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return ("Published on \(dateString)")
    }
}
