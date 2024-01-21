//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation
import SharedModel

public extension NumberFormatter {
    static func currencyFormatter(for currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func convertMinorUnits(_ units: Int, currencyCode: String) -> Decimal {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currencyISOCode
        currencyFormatter.currencyCode = currencyCode.uppercased()
        return Decimal(units) / pow(10, currencyFormatter.minimumFractionDigits)
    }
    
    static func formattedCurrencyFrom(amount: Amount) -> String? {
        let formatter = NumberFormatter.currencyFormatter(for: amount.currency)
        let majorUnits = formatter.getMajorUnits(code: amount.currency, amount: amount.minorUnits)
        let stringValue = formatter.string(from: majorUnits as NSNumber)
        return stringValue
    }
    
    func getMajorUnits(code: String, amount: Int) -> Decimal {
        return Decimal(amount) / pow(10, self.minimumFractionDigits)
    }
}
