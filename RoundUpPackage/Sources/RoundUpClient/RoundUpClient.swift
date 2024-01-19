//
//  File.swift
//  
//
//  Created by Jack Young on 14/01/2024.
//

import Foundation
import Common

public protocol RoundUpClientProtocol {
    func roundUpSpend(code: String, _ transactionAmount: Int) -> Int
}

public struct RoundUpClient: RoundUpClientProtocol {
    
    public init(){}
    
    public func roundUpSpend(code: String, _ transactionAmount: Int) -> Int {
        let formatter = NumberFormatter.currencyFormatter(for: code)
        let amountDecimal = Decimal(transactionAmount) / pow(10, formatter.minimumFractionDigits)
        let amountDecimalAsDouble = NSDecimalNumber(decimal: amountDecimal).doubleValue
        let roundUpAmountDouble = (ceil(amountDecimalAsDouble) - amountDecimalAsDouble)
        let roundUpAmountDoubleAsMinorUnits = roundUpAmountDouble * pow(Double(10), Double(formatter.minimumFractionDigits))
    
        return Int(roundUpAmountDoubleAsMinorUnits)
    }
    
}
