//
//  TestabilityAppStoryboardTests.swift
//  TestabilityAppStoryboardTests
//
//  Created by William Do on 06/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import XCTest
@testable import TestabilityAppStoryboard

class StatusIndicatorTests: XCTestCase {
    
    func testStatusIndicatorOfEmptyStatuses() {
        
        let status = statusIndicatorFor([])
    
        XCTAssertEqual(status, "❓")
        
    }
    
    func testStatusIndicatorOfSingleStatus() {
        
        let status = statusIndicatorFor([
            LineStatus(statusSeverity: 10000, statusSeverityDescription: "okay")
        ])
        
        XCTAssertEqual(status, "🟢")
        
    }
    
    func testStatusIndicatorOfUnknownStatus() {
        
        let status = statusIndicatorFor([
            LineStatus(statusSeverity: 20000, statusSeverityDescription: "okay")
        ])
        
        XCTAssertEqual(status, "🤷")
        
    }
    
    func testStatusIndicatorOfMultipleStatuses() {
        
        let status = statusIndicatorFor([
            LineStatus(statusSeverity: 10000, statusSeverityDescription: "okay"),
            LineStatus(statusSeverity: 10001, statusSeverityDescription: "not okay"),
            LineStatus(statusSeverity: 10002, statusSeverityDescription: "pretty bad")
        ])
        
        XCTAssertEqual(status, "🔴")
        
    }

}
