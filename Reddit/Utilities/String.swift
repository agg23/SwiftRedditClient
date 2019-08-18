//
//  String.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/18/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

func truncate(_ score: Int) -> String {
    let scoreDouble = Double(score)
    
    if scoreDouble >= 10000 && scoreDouble <= 99999 {
        // Less than 100k, show 3 digits (1 decimal) + unit
        return String(format: "%.1fK", locale: Locale.current, scoreDouble/1000).replacingOccurrences(of: ".0", with: "")
    } else if scoreDouble >= 100000 && scoreDouble <= 999999 {
        // Greater than 100k, show 3 digits (no decimal) + unit
        return String(format: "%.0fK", locale: Locale.current, scoreDouble/1000).replacingOccurrences(of: ".0", with: "")
    } else if scoreDouble > 999999 {
        return String(format: "%.0fM", locale: Locale.current, scoreDouble/1000000).replacingOccurrences(of: ".0", with: "")
    }
    
    return String(format: "%.0f", locale: Locale.current, scoreDouble)
}

func format(_ score: Int) -> String {
    return String(format: "%d", locale: Locale.current, score)
}
