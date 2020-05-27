//
//  LineStatusFormatter.swift
//  TestabilityAppStoryboard
//
//  Created by William Do on 07/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import Foundation

let statusIndicator = [
    0: "👍",
    20: "⛔️",
    
    // Only for unit testing
    10000: "🟢",
    10001: "🟡",
    10002: "🔴",
]

func statusIndicatorFor(_ status: [LineStatus]) -> String {
    guard let mostSevereStatus = status.max(by: {$0.statusSeverity < $1.statusSeverity}) else {
        return "❓"
    }
    
    return statusIndicator[mostSevereStatus.statusSeverity] ?? "🤷"
    
}
