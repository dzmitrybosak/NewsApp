//
//  NewsTests.swift
//  NewsTests
//
//  Created by Dzmitry Bosak on 10/3/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import XCTest
@testable import News

class NewsTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToAPIGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=97d1c467a9584168a55584355bc778a8")
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Asynchronous test: faster fail
    func testCallToAPICompletes() {
        // given
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=97d1c467a9584168a55584355bc778a8")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
