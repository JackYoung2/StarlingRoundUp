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
    
//    static func formatCurrency(minorUnits: Int, currencyCode: String) -> Decimal? {
//        let majorUnits = Decimal(value: Double(minorUnits) / 100.0)
//        return majorUnits as Decimal
//    }
    
//    static func currencyString(_ code: String, minorUnits: Int) -> String? {
//        let formatter = NumberFormatter.currencyFormatter(for: code)
//        let value = Self.formatCurrency(minorUnits: minorUnits, currencyCode: code)
//        let stringValue = formatter.string(from: minorUnits as NSNumber)
//        return stringValue
//    }
    
    func convertMinorUnits(_ units: Int, currencyCode: String) -> Decimal {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currencyISOCode
        currencyFormatter.currencyCode = currencyCode.uppercased()

        return Decimal(units) / pow(10, currencyFormatter.minimumFractionDigits)
    }
    
    static func formattedCurrencyFrom(amount: Amount) -> String? {
        
//        print(amount)
        
        let formatter = NumberFormatter.currencyFormatter(for: amount.currency)
        let majorUnits = formatter.getMajorUnits(code: amount.currency, amount: amount.minorUnits)
        let stringValue = formatter.string(from: majorUnits as NSNumber)
        return stringValue
    }
    
    func getMajorUnits(code: String, amount: Int) -> Decimal {
//        print(Decimal(amount) / pow(10, self.minimumFractionDigits))
        return Decimal(amount) / pow(10, self.minimumFractionDigits)
    }
}

//public extension Int {
//    var asCurrencyString: String? {
//       
//        
//       
//        let stringValue = formatter.string(from: self as NSNumber)
//        return stringValue
//    }
//}
