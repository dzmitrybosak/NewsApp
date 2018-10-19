//
//  WebService.swift
//  News
//
//  Created by Dzmitry Bosak on 9/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

// MARK: - Constants

private enum Constants {
    static let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=97d1c467a9584168a55584355bc778a8"
}

// Type alias with parameters: array of cities and optional error (if it will be).
typealias NewsCallback = (_ news: [Article], _ error: Error?) -> Void

final class WebService {

    // MARK: - Properties
    static let shared = WebService()
    private init() {}
        
    // Set up the URL Session
    private let session = URLSession.shared
        
    // Set up JSON Decoder
    private let decoder = JSONDecoder()
        
    // Load URL, decode JSON and parse.
    // This method takes closure CitiesCallBack.
    func getNews(callback: @escaping NewsCallback) {
        
        // Setup URL
        // If url is wrong, empty array and empty error will return.
        guard let url = URL(string: Constants.url) else {
            callback([], nil)
            return
        }
        
        // Setup URL Request
        let urlRequest = URLRequest(url: url)
        
        // Load data from JSON and parse it
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            // Сonverting a weak reference to a strong reference for ARM.
            guard let strongSelf = self else {
                callback([], nil)
                return
            }
            
            // Return error if error will be error.
            if let error = error {
                callback([], error)
                return
            }
            
            // Return empry array and ampty error if data will be data.
            guard let data = data else {
                callback([], nil)
                return
            }
            
            do {
                strongSelf.decoder.dateDecodingStrategy = .iso8601
                let parsedResult = try strongSelf.decoder.decode(News.self, from: data)
                
                // Return loaded cities and empty error.
                callback(parsedResult.news, nil)
                
            } catch (let error) {
                print("Can't decode news. Error: \(error)")
                
                // Return empty array and error.
                callback([], error)
            }
        }
        task.resume()
    }
}
