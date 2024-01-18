//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation


public extension NumberFormatter {
    static var currencyFormatter: Self {
        let formatter = Self.init()
        formatter.numberStyle = .currency
        formatter.locale = .current
        #if DEBUG
        formatter.locale = Locale(identifier: "en_GB")
        #endif
        return formatter
    }
}

public extension Decimal {
    var asCurrencyString: String? {
        let formatter = NumberFormatter.currencyFormatter
        let stringValue = formatter.string(from: self as NSNumber)
        return stringValue
    }
}
