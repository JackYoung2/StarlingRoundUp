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
    
    let roundingUpHandler: NSDecimalNumberHandler

    
    public init(roundingUpHandler: NSDecimalNumberHandler? = nil){
        self.roundingUpHandler = roundingUpHandler ??
        NSDecimalNumberHandler(
            roundingMode: .up,
            scale: 0,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
    }
    
    public func roundUpSpend(code: String, _ transactionAmount: Int) -> Int {
        let formatter = NumberFormatter.currencyFormatter(for: code)
        let divisor = pow(10.0, Double(formatter.maximumFractionDigits))
        let decimalValue = Double(transactionAmount) / divisor
        let rounded = decimalValue.rounded(.up)
        let difference = abs(Decimal(decimalValue) - Decimal(rounded))
        let differeceAsMinorUnits = difference * Decimal(divisor)
        let cast = NSDecimalNumber(decimal: differeceAsMinorUnits)
        return Int(truncating: cast)
    }
    
}
