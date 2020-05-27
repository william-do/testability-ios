//
//  TestableViewModelTests.swift
//  TestabilityAppStoryboardTests
//
//  Created by William Do on 11/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import XCTest
@testable import TestabilityAppStoryboard

class ViewModelTests: XCTestCase {
    
    func testSuccessResponse() {
        let queue = DispatchQueue(label: #function)
        
        let viewModel = TubeStatusViewModel(queue: queue, urlSession: MockUrlSession(), statusUrl: URL(string: "https://api.tfl.gov.uk/Line/Mode/tube/Status")!)
        
        var successCalled = false
        
        let expectation = self.expectation(description: #function)
        
        viewModel.downloadStatusFromTfl(
            onError: { _ in
        },
            onSuccess: {
                _ in
                successCalled = true
                expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(successCalled)
        
    }

}

class MockUrlSessionDataTask : URLSessionDataTask {
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    init(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        let tubeStatus: [Line] = []
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tubeStatus)
            completionHandler(Data(data), HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        } catch {
            
        }
    }
}

class MockUrlSession : URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockUrlSessionDataTask(completionHandler)
    }
}
